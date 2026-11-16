# b2bi/ - Day 7 capstone (Sterling B2Bi through Argo CD)

Put two things in this folder, commit and push:

```
b2bi/
  ibm-b2bi-prod/                 <- the chart you already extracted (helm pull ... --untar), version 3.2.2
  b2bi-values-override.yaml      <- copy of Sterling-Explore/RCA/b2bi-values-override.yaml
```

Rules before you commit:

1. **No secrets in Git.** The override file must only *reference* secrets by name
   (`ibm-entitlement-key`, `b2bi-db-secret`, `b2bi-system-passphrase`). Those secrets stay in the
   `b2bi` namespace, created by hand or as SealedSecrets (Day 6).
2. **Render it locally first.** If this fails, Argo CD will fail the same way:
   ```bash
   helm template b2bi ./ibm-b2bi-prod -n b2bi -f b2bi-values-override.yaml > /tmp/b2bi-rendered.yaml && echo RENDER OK
   ```
3. **Schema already created?** If the Oracle schema exists from your earlier helm install, set
   `dataSetup.enabled: false` in the override file *before* the first Argo CD sync.
   Argo CD runs Helm hooks on **every** sync, not only on install.
4. **Existing helm release?** Run `helm uninstall b2bi -n b2bi` first (PV is `Retain`, schema is kept),
   so there is only one owner. Otherwise `helm list` keeps showing a release that Argo CD does not use.

Then: `kubectl apply -f argocd/capstone/b2bi-app.yaml`, open the app in the UI, read **APP DIFF**, press **SYNC**.
