#!/usr/bin/env bash
set -euo pipefail
# master1에 ansible 디렉토리 복사 및 베이스라인 자동화

# dotenv auto-load
if [ -f ".env" ]; then set -o allexport; . ".env"; set +o allexport; fi


# 변수: master1 접속 정보
MASTER1_IP="${1:-}"
SSH_USER="${SSH_USER:-${ANSIBLE_REMOTE_USER:-${TF_VAR_ssh_user:-${2:-}}}}"
SSH_KEY="${SSH_KEY:-${3:-}}"

if [ -z "$MASTER1_IP" ] || [ -z "$SSH_USER" ] || [ -z "$SSH_KEY" ]; then
	echo "Usage: $0 <MASTER1_IP> <SSH_USER> <SSH_KEY_PATH>"
	exit 1
fi


# SSH 포트가 열릴 때까지 최대 20회(약 3분) 재시도
RETRY_COUNT=0
MAX_RETRIES=20
SLEEP_SEC=10
echo "[INFO] master1 SSH 접속 가능 여부 확인 중..."
until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" "$SSH_USER@$MASTER1_IP" 'echo SSH_OK' 2>/dev/null | grep -q SSH_OK; do
	RETRY_COUNT=$((RETRY_COUNT+1))
	if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
		echo "[ERROR] master1 SSH 접속 불가. $((MAX_RETRIES*SLEEP_SEC/60))분 대기 후 실패 처리."
		exit 1
	fi
	echo "[WAIT] SSH 포트 열릴 때까지 대기 중... ($RETRY_COUNT/$MAX_RETRIES)"
	sleep $SLEEP_SEC
done
echo "[INFO] master1 SSH 접속 성공! 후속 작업 진행."

# 1. ansible 디렉토리 복사 (ansible.cfg 포함)
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" -r "$(cd "$(dirname "$0")" && cd infra/ansible && pwd)" "$SSH_USER@$MASTER1_IP:~/ansible"

# 2. hosts.ini 자동 생성 및 master1에 복사 (tofu output 필요)
if command -v tofu >/dev/null 2>&1; then
	TOFU_OUTPUT_JSON=$(tofu output -json)
	echo "$TOFU_OUTPUT_JSON" | python3 infra/ansible/scripts/render_hosts_from_tofu.py > /tmp/hosts.ini
	scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i "$SSH_KEY" /tmp/hosts.ini "$SSH_USER@$MASTER1_IP:~/ansible/inventories/prod/hosts.ini"
else
	echo "[WARN] tofu 명령어를 찾을 수 없어 hosts.ini 자동 생성 생략. 수동으로 복사 필요."
fi

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
