#!/bin/bash
# master1에 ansible 디렉토리 복사 및 베이스라인 자동화

set -e


# 변수: master1 접속 정보
MASTER1_IP="$1"
SSH_USER="${SSH_USER:-$2}"
SSH_KEY="${SSH_KEY:-$3}"

if [ -z "$MASTER1_IP" ] || [ -z "$SSH_USER" ] || [ -z "$SSH_KEY" ]; then
	echo "Usage: $0 <MASTER1_IP> <SSH_USER> <SSH_KEY_PATH>"
	exit 1
fi

# 1. ansible 디렉토리 복사 (ansible.cfg 포함)
scp -i "$SSH_KEY" -r "$(cd "$(dirname "$0")" && cd infra/ansible && pwd)" "$SSH_USER@$MASTER1_IP:~/ansible"

# 2. master1에서 ansible 설치 및 플레이북 실행
ssh -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" <<'EOF'
sudo apt-get update
sudo apt-get install -y ansible
cd ~/ansible
ls -al
ls -al roles
ls -al playbooks
cat ansible.cfg
ansible-playbook -i inventories/prod/hosts.ini playbooks/base-os.yml -t base-os
EOF
