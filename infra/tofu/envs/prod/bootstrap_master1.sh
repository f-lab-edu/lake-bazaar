#!/usr/bin/env bash
set -euo pipefail
# This script now runs ON master1. It assumes ~/.env and ~/ansible are already staged by Terraform.

# 0) Load environment from ~/.env if present
if [ -f "$HOME/.env" ]; then set -o allexport; . "$HOME/.env"; set +o allexport; fi

# 1) Params: <MASTER1_IP> <SSH_KEY_PATH> (IP kept for backward compatibility; unused)
MASTER1_IP=${1:-}
SSH_KEY=${2:-}
if [ -z "${SSH_KEY:-}" ]; then
	echo "Usage: $0 <MASTER1_IP> <SSH_KEY_PATH>"
	exit 1
fi

# 2) Ensure ansible dir exists (should be provided by Terraform file provisioner)
mkdir -p "$HOME/ansible"
cd "$HOME/ansible"

echo "==== ansible.cfg ===="
cat ansible.cfg || true
echo "==== INVENTORY (hosts.ini) ===="
cat inventories/prod/hosts.ini || true
echo "==== TREE (top-level) ===="
ls -la || true
echo "==== FIND (depth<=2) ===="
find . -maxdepth 2 -type f | sed -n '1,200p' || true

# 3) Determine remote user for Ansible
ANS_USER="${ANSIBLE_REMOTE_USER:-${TF_VAR_ssh_user:-${USER}}}"
export USERS_SSH_DEFAULT_USER="$ANS_USER"

# 4) If ansible is missing, try best-effort install without failing the run
if ! command -v ansible-playbook >/dev/null 2>&1; then
	if command -v apt-get >/dev/null 2>&1; then
		(sudo -n apt-get update && sudo -n apt-get install -y ansible) || true
	fi
fi

# 5) Locate playbook path and run using the provided private key (staged at /tmp/ssh_key by Terraform)
PLAYBOOK_PATH="playbooks/base-os.yml"
if [ ! -f "$PLAYBOOK_PATH" ] && [ -f "ansible/playbooks/base-os.yml" ]; then
	cd ansible
	PLAYBOOK_PATH="playbooks/base-os.yml"
fi

ansible-playbook -i inventories/prod/hosts.ini "$PLAYBOOK_PATH" -e ansible_user="$ANS_USER" --private-key "$SSH_KEY"

# 6) Run SSH mesh validation playbook if present
MESH_PLAYBOOK_PATH="playbooks/cluster-ssh-mesh.yml"
if [ -f "$MESH_PLAYBOOK_PATH" ]; then
	echo "==== Running SSH mesh validation: $MESH_PLAYBOOK_PATH ===="
	ansible-playbook -i inventories/prod/hosts.ini "$MESH_PLAYBOOK_PATH" -e ansible_user="$ANS_USER" --private-key "$SSH_KEY"
else
	echo "==== SSH mesh playbook not found; skipping: $MESH_PLAYBOOK_PATH ===="
fi
