#!/usr/bin/env bash
# Removes the lab: ApplicationSets, Applications (and the resources of apps that have the
# resources-finalizer), the lab namespaces, and finally Argo CD itself.
# The b2bi Application has NO finalizer, so B2Bi itself keeps running.
set -euo pipefail
read -r -p "This deletes all Argo CD apps, the lab-* namespaces and Argo CD. Type yes to continue: " ok
[ "$ok" = "yes" ] || { echo "aborted"; exit 1; }
ARGOCD_VERSION="${ARGOCD_VERSION:-stable}"

kubectl -n argocd delete applicationsets --all --wait=true --timeout=300s || true
kubectl -n argocd delete applications --all --wait=true --timeout=600s || true
kubectl delete -n argocd -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml" --ignore-not-found
kubectl delete namespace argocd --ignore-not-found
for ns in lab-guestbook lab-dev lab-qa lab-prod lab-uat lab-helm lab-podinfo lab-waves; do
  kubectl delete namespace "$ns" --ignore-not-found --wait=false
done
echo "Done. Note: CRDs (applications.argoproj.io, ...) are removed together with install.yaml."
