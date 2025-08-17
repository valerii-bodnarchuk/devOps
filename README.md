# Val DevOps Starter

## Local
- `docker compose up --build` → http://localhost:3000/health, /metrics

## CI
- PR → build+test → build image → Trivy scan
- Tag push → extend to push to GHCR/ECR

## K8s
- Edit `k8s/overlays/staging/kustomization.yaml` image tag
- `make k8s-apply`

## Terraform (AWS)
- Set S3 backend (create bucket & dynamodb lock once)
- `make tf-init && make tf-plan && make tf-apply`

## Secrets
- Local via `.env`
- Prod via Sealed Secrets / External Secrets (AWS Secrets Manager)

## Observability
- Prometheus scrapes `/metrics` (see `app/src/metrics.ts`)
