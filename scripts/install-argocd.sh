#!/usr/bin/env bash
# Installs Argo CD on the current kubectl cluster and exposes the UI as a NodePort.
# Run on the control-plane node (as the user that has ~/.kube/config):
#   bash scripts/install-argocd.sh                 # latest stable
#   ARGOCD_VERSION=v3.6.1 bash scripts/install-argocd.sh   # pinned (recommended for anything real)
set -euo pipefail

ARGOCD_VERSION="${ARGOCD_VERSION:-stable}"
HTTP_NODEPORT="${HTTP_NODEPORT:-30080}"
HTTPS_NODEPORT="${HTTPS_NODEPORT:-30443}"
MANIFEST="https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo ">> 1/4 Creating namespace argocd"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

echo ">> 2/4 Installing Argo CD (${ARGOCD_VERSION})"
# --server-side is required: the Argo CD CRDs are too big for a client-side apply annotation
kubectl apply -n argocd --server-side --force-conflicts -f "$MANIFEST"

echo ">> 3/4 Waiting for the components to be ready (up to 5 minutes)"
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
kubectl -n argocd get pods

echo ">> 4/4 Exposing the UI on NodePort ${HTTPS_NODEPORT} (https) / ${HTTP_NODEPORT} (http)"
kubectl -n argocd patch svc argocd-server --type merge -p "{
  \"spec\": {\"type\": \"NodePort\", \"ports\": [
    {\"name\": \"http\",  \"port\": 80,  \"protocol\": \"TCP\", \"targetPort\": 8080, \"nodePort\": ${HTTP_NODEPORT}},
    {\"name\": \"https\", \"port\": 443, \"protocol\": \"TCP\", \"targetPort\": 8080, \"nodePort\": ${HTTPS_NODEPORT}}
  ]}}"
kubectl -n argocd get svc argocd-server

PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
NODE_IP=$(hostname -I | awk '{print $1}')
cat <<EOF

=====================================================================
 Argo CD is installed.
 UI (from your laptop):  https://<EC2-PUBLIC-IP>:${HTTPS_NODEPORT}
 UI (inside the VPC):    https://${NODE_IP}:${HTTPS_NODEPORT}
 Username:               admin
 Initial password:       ${PASS}

 The browser will warn about a self-signed certificate - that is expected in the lab.
 Make sure the AWS security group allows YOUR IP to port ${HTTPS_NODEPORT}.
 Next: change the password (Day 1, step 7) and run scripts/install-cli.sh
=====================================================================
EOF
