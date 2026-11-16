#!/usr/bin/env bash
# Pretends to be a CI pipeline: writes a new image tag for one environment, commits and pushes.
#   bash scripts/simulate-ci-release.sh dev 6.7.0     # "CI" releases 6.7.0 to dev
#   bash scripts/simulate-ci-release.sh dev 9.9.9     # Day 7 drill: a tag that does not exist
set -euo pipefail
ENV="${1:?usage: bash scripts/simulate-ci-release.sh <dev|qa|prod> <tag>}"
TAG="${2:?usage: bash scripts/simulate-ci-release.sh <dev|qa|prod> <tag>}"
cd "$(dirname "$0")/.."
FILE="apps/hello-web/overlays/${ENV}/kustomization.yaml"
[ -f "$FILE" ] || { echo "no such overlay: $FILE"; exit 1; }
sed -i -E "s/^( *newTag:).*/\1 \"${TAG}\"/" "$FILE"
git add "$FILE"
git commit -m "ci: hello-web ${ENV} -> ${TAG}"
git push
echo
echo "Pushed. Argo CD will pick it up within ~3 minutes (or now with:  argocd app get hello-web-${ENV} --refresh)"
