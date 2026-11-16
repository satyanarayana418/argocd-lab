#!/usr/bin/env bash
# Installs the argocd CLI on a Linux amd64 node.
#   bash scripts/install-cli.sh                  # latest release
#   ARGOCD_CLI_VERSION=v3.6.1 bash scripts/install-cli.sh
# Tip: keep the CLI version the same as the server version (argocd version shows both).
set -euo pipefail
VERSION="${ARGOCD_CLI_VERSION:-latest}"
if [ "$VERSION" = "latest" ]; then
  URL="https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64"
else
  URL="https://github.com/argoproj/argo-cd/releases/download/${VERSION}/argocd-linux-amd64"
fi
curl -sSL -o /tmp/argocd-linux-amd64 "$URL"
sudo install -m 555 /tmp/argocd-linux-amd64 /usr/local/bin/argocd
rm -f /tmp/argocd-linux-amd64
argocd version --client --short || argocd version --client
