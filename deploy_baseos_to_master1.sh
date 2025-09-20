#!/usr/bin/env bash
set -euo pipefail
# master1에 ansible 디렉토리 복사 및 베이스라인 자동화

# dotenv auto-load
if [ -f ".env" ]; then set -o allexport; . ".env"; set +o allexport; fi


MASTER1_IP=${1:-}
SSH_KEY=${2:-}
SSH_USER=${SSH_USER:-${ANSIBLE_REMOTE_USER:-${TF_VAR_ssh_user:-"debian"}}}
if [ -z "$MASTER1_IP" ] || [ -z "$SSH_KEY" ]; then
	echo "Usage: $0 <MASTER1_IP> <SSH_KEY_PATH>"
	exit 1
fi



# ansible 디렉토리와 .env는 이미 file provisioner로 ~/ansible, ~/.env에 복사됨

# 2. master1에서 ansible 설치 및 플레이북 실행 (.env 환경변수 적용)
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" <<'EOF'
set -euo pipefail
if [ -f "$HOME/.env" ]; then set -a; . "$HOME/.env"; set +a; fi
sudo apt-get update
sudo apt-get install -y ansible
cd ~/ansible
ls -al
ls -al roles
ls -al playbooks
cat ansible.cfg
if [ -f inventories/prod/hosts.ini ]; then INV="-i inventories/prod/hosts.ini"; else INV=""; fi
ansible-playbook $INV playbooks/base-os.yml
EOF
