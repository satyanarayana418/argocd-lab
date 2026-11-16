#!/usr/bin/env bash
# Logs the argocd CLI in as admin (run on a cluster node).
#   bash scripts/login.sh                       # uses the initial admin password
#   ARGOCD_PASSWORD='MyNewPass' bash scripts/login.sh   # after you changed it
set -euo pipefail
NODE_IP="${NODE_IP:-$(hostname -I | awk '{print $1}')}"
PORT="${PORT:-30443}"
if [ -z "${ARGOCD_PASSWORD:-}" ]; then
  ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
fi
argocd login "${NODE_IP}:${PORT}" --username admin --password "$ARGOCD_PASSWORD" --insecure
argocd account get-user-info
argocd version
