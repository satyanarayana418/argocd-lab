#!/usr/bin/env bash
# Replaces the placeholder YOUR_GITHUB_USER in every YAML/Markdown file with your GitHub user name.
#   bash scripts/set-repo-url.sh <your-github-user>
set -euo pipefail
GH_USER="${1:?usage: bash scripts/set-repo-url.sh <your-github-user>}"
cd "$(dirname "$0")/.."
grep -rl --include='*.yaml' --include='*.yml' --include='*.md' 'YOUR_GITHUB_USER' . | xargs -r sed -i "s/YOUR_GITHUB_USER/${GH_USER}/g"
echo "Repo URL is now: https://github.com/${GH_USER}/argocd-lab.git"
grep -rn "github.com/${GH_USER}/argocd-lab" --include='*.yaml' . | head -20
