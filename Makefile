IMAGE?=ghcr.io/your-org/val-api
TAG?=dev

.PHONY: build run push k8s-apply tf-init tf-plan tf-apply

build:
	docker build -t $(IMAGE):$(TAG) .

run:
	docker compose up --build

push:
	docker buildx build --platform linux/amd64 -t $(IMAGE):$(TAG) --push .

k8s-apply:
	kubectl apply -k k8s/overlays/staging

tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan -var="env=staging"

tf-apply:
	cd terraform && terraform apply -auto-approve -var="env=staging"