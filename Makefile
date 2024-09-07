SHELL := /bin/bash
include .env
export
export APP_NAME := $(basename $(notdir $(shell pwd)))

.PHONY: help
help: ## display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: up
up: ## docker compose up with air hot reload
	@docker compose --project-name ${APP_NAME} --file ./compose.yaml up -d

.PHONY: down
down: ## docker compose down
	@docker compose --project-name ${APP_NAME} down --volumes

.PHONY: login
login: ## login to the container
	@koyeb login --token ${KOYEB_TOKEN}
	@docker login --username ${USERNAME} --password ${PASSWORD}

.PHONY: container
container: ## build and push container. need to login first
	@docker build --file ./Dockerfile --build-arg PB_VERSION --platform linux/amd64 --tag otakakot/pocketbase:${PB_VERSION} --push .
	@docker rmi otakakot/pocketbase:${PB_VERSION}
