#!/bin/bash
# master1에 ansible 디렉토리 복사 및 베이스라인 자동화

set -e


# 변수: master1 접속 정보
MASTER1_IP="$1"
SSH_USER="chanyong"  # GCP에서 권장하는 계정명
SSH_KEY="$2"      # ex) ~/.ssh/GCPKEY


# 1-1. master1의 known_hosts 파일 삭제 (호스트키 검증 우회)
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" 'rm -f ~/.ssh/known_hosts'


# 1. master1에 ansible 디렉토리 복사 (ansible.cfg 포함)
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" 'rm -rf ~/ansible && mkdir -p ~/ansible'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" -r ../../../ansible/* "$SSH_USER@$MASTER1_IP:~/ansible/"

# 1-2. 현재 tofu outputs 기반으로 hosts.ini 생성 후 master1에 반영 (ansible_host 포함)
# 로컬에서 렌더링해 업로드 (master1에 tofu 설치 불필요)
TOFU_OUTPUT_JSON=$(tofu output -json)
echo "$TOFU_OUTPUT_JSON" | python3 ../../../ansible/scripts/render_hosts_from_tofu.py > /tmp/hosts.ini
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" /tmp/hosts.ini "$SSH_USER@$MASTER1_IP:~/ansible/inventories/prod/hosts.ini"

# 2. 로컬의 SSH 비공개키와 공개키를 master1의 ~/.ssh/에 복사 및 권한 설정, authorized_keys를 공개키로만 덮어쓰기
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" 'mkdir -p ~/.ssh && chmod 700 ~/.ssh'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_KEY" "$SSH_USER@$MASTER1_IP:~/.ssh/GCPKEY"
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "${SSH_KEY}.pub" "$SSH_USER@$MASTER1_IP:~/.ssh/GCPKEY.pub"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" 'cat ~/.ssh/GCPKEY.pub > ~/.ssh/authorized_keys && chmod 600 ~/.ssh/GCPKEY ~/.ssh/GCPKEY.pub ~/.ssh/authorized_keys'

# 3. master1에서 ansible 설치 및 플레이북 실행
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" <<'EOF'
sudo apt-get update
sudo apt-get install -y ansible
cd ~/ansible
ls -al
ls -al roles
ls -al playbooks
cat ansible.cfg
echo "==== INVENTORY (hosts.ini) ===="
cat inventories/prod/hosts.ini
ansible-playbook -i inventories/prod/hosts.ini playbooks/base-os.yml
EOF
