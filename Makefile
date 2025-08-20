# --- Vars ---
APP        ?= val-api
IMAGE      ?= ghcr.io/$(GITHUB_USER)/$(REPO)/$(APP)
TAG        ?= dev
PLATFORMS  ?= linux/amd64
COMPOSE    ?= docker compose
CI_NODE    ?= 20

# Авто-определение repo из git
REPO       ?= $(shell git config --get remote.origin.url | sed -E 's#.*/(.*)\.git#\1#')
GITHUB_USER?= $(shell git config user.name | tr ' ' '-')

# Загружать .env если есть
-include .env
export

# --- Phony ---
.PHONY: help build run up down logs test lint scan sbom tag push release clean migrate history size

help: ## Показать цели
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | sed 's/:.*##/: /' | sort

# --- Docker ---
build: ## buildx multi-stage image
	docker buildx build --platform $(PLATFORMS) -t $(APP):$(TAG) .

run: ## run local container
	docker run --rm -p 3000:3000 --name $(APP) $(APP):$(TAG)

history: ## показать слои образа
	docker history $(APP):$(TAG)

size: ## размер образа
	@docker images | grep $(APP) | grep $(TAG) || true

# --- Compose ---
up: ## compose up API+DB+Redis+migrate
	$(COMPOSE) up -d --build

down: ## compose down
	$(COMPOSE) down -v

logs: ## логи API
	$(COMPOSE) logs -f api

migrate: ## одноразовая миграция
	$(COMPOSE) run --rm migrate

# --- Dev checks ---
lint: ## npm lint
	cd app && npm run lint --if-present

test: ## npm test
	cd app && npm test --if-present -- --passWithNoTests

# --- Security ---
scan: ## Trivy scan локального образа
	trivy image $(APP):$(TAG) || true

sbom: ## SBOM Syft
	syft $(APP):$(TAG) -o spdx-json > sbom.json && echo "SBOM -> sbom.json"

# --- Release to GHCR ---
tag: ## создать git-тег vX.Y.Z (use: make tag v=0.1.0)
	@test -n "$(v)" || (echo "Usage: make tag v=0.1.0" && false)
	git tag v$(v) && git push origin v$(v)

push: ## push локальный образ в GHCR (нужен docker login ghcr.io)
	docker tag $(APP):$(TAG) $(IMAGE):$(TAG)
	docker push $(IMAGE):$(TAG)

release: build push ## build+push (TAG используется)
	@echo "released $(IMAGE):$(TAG)"
