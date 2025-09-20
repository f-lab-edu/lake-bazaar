#!/usr/bin/env bash
set -euo pipefail

# Auto-load dotenv in repo root if present
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
if [ -f "$REPO_ROOT/.env" ]; then
  set -o allexport
  . "$REPO_ROOT/.env"
  set +o allexport
fi

# Export TF_VAR_* from commonly used settings if not already set
export TF_VAR_project_id="${TF_VAR_project_id:-${PROJECT_ID:-${GOOGLE_PROJECT:-""}}}"
export TF_VAR_region="${TF_VAR_region:-${REGION:-"us-central1"}}"
export TF_VAR_zone="${TF_VAR_zone:-${ZONE:-"us-central1-a"}}"
export TF_VAR_gcp_credentials_file="${TF_VAR_gcp_credentials_file:-${GOOGLE_APPLICATION_CREDENTIALS:-""}}"
export TF_VAR_ssh_user="${TF_VAR_ssh_user:-${ANSIBLE_REMOTE_USER:-"debian"}}"

echo "[envrc] Exported TF_VAR_* and loaded .env if present."