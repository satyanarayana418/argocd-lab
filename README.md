# argocd-lab-test

GitOps lab repository for the 7-day Argo CD learning pack.
Push this folder to GitHub as **`argocd-lab`**, then follow `03-ArgoCD-7-Day-Hands-On-Lab-Workbook.docx`.

## First-time setup

```bash
# on your laptop (Git Bash) or on the k8s control-plane node
cd argocd-lab
bash scripts/set-repo-url.sh <your-github-user>      # Windows: scripts\set-repo-url.ps1 -GitHubUser <user>
git init -b main
git add .
git commit -m "argocd lab: initial content"
git remote add origin https://github.com/<your-github-user>/argocd-lab.git
git push -u origin main
```

## Layout

| Path | What it is | Used on |
|---|---|---|
| `apps/hello-web/` | Kustomize app: `base/` + `overlays/dev,qa,prod` | Day 2, 5, 7 |
| `apps/hello-chart/` | Your own Helm chart with `values-dev.yaml` / `values-prod.yaml` | Day 3 |
| `apps/waves-demo/` | Sync waves + PreSync / PostSync hooks | Day 4 |
| `argocd/projects/` | AppProject `lab` (allowed repos, `lab-*` namespaces, roles) | Day 2, 6 |
| `argocd/single/` | Applications you apply by hand while learning | Day 2, 3 |
| `argocd/apps/` | Children of the App of Apps (`root-app`) | Day 3–5 |
| `argocd/root-app.yaml` | App of Apps | Day 5 |
| `argocd/appsets/` | ApplicationSet: hello-web for dev / qa / prod | Day 5 |
| `argocd/security/` | Local users + RBAC patches | Day 6 |
| `argocd/platform/` | Sealed Secrets controller installed by Argo CD | Day 6 |
| `argocd/capstone/` + `b2bi/` | Sterling B2Bi chart managed by Argo CD | Day 7 |
| `ci-example/` | Reference GitHub Actions pipeline (build image, bump tag) | Day 7 |
| `scripts/` | install / login / simulate CI / uninstall helpers | all week |

## NodePorts used (open them to YOUR IP in the AWS security group)

| Port | What |
|---|---|
| 30443 / 30080 | Argo CD UI (https / http) |
| 30081 / 30082 / 30083 | hello-web dev / qa / prod |
| 30084 | hello-chart (own Helm chart) |
| 30085 | podinfo (Helm repo chart) |
| 30086 | waves-demo |
| 30000, 30005 | already used by B2Bi - do not reuse |

## Golden rule

Change things **in Git**, not with `kubectl edit`. Argo CD will either undo your manual change (selfHeal) or show the app as OutOfSync.
