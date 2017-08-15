.DEFAULT_GOAL := help
.PHONY: help
.SILENT:

GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)
KEY    := $(shell date +%s | sha256sum | base64 | head -c 32 ; echo)

APPDIR="application/"

## Runs the containers
run: docker-up

## Stops the containers
stop: docker-down

## Builds the application
build: docker-up install migrate create-admin

## Rebuilds the docker images
rebuild: docker-build docker-up install

## Updates the application
update: pull install docker-up
	docker-compose exec php-fpm php artisan app:update --no-backup

## Gets the status of the containers
status:
	docker-compose ps

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

docker-build:
	docker-compose build

generate-key:
	@sed -i "s/JWT_SECRET=changeme/JWT_SECRET=${KEY}/g" $(APPDIR)/.env
	@docker-compose exec php-fpm php artisan key:generate --force

create-admin: generate-key
	docker-compose exec php-fpm php artisan deployer:create-user admin admin@example.com changeme --no-email

migrate:
	docker-compose exec php-fpm php artisan migrate

clean: docker-down
	@cd $(APPDIR) && $(MAKE) clean

install: clone
	docker-compose exec php-fpm composer install --optimize-autoloader --no-dev --prefer-dist --no-interaction --no-suggest
	docker-compose exec node yarn install --production

install-dev: clone
	docker-compose exec php-fpm composer install --no-interaction --no-suggest --prefer-dist --no-suggest
	docker-compose exec node yarn install

clone:
	@if [ ! -e ./$(APPDIR) ]; then \
		git clone https://github.com/REBELinBLUE/deployer $(APPDIR); \
		cp phpdocker/laravel_env ./$(APPDIR)/.env; \
	fi

pull: clone
	@cd $(APPDIR) && git pull

## Prints this help
help:
	@echo "\nUsage: make ${YELLOW}<target>${RESET}\n\nThe following targets are available:\n"
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "  ${YELLOW}%-30s${GREEN}%s${RESET} %s\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
