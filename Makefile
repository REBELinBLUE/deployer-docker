.DEFAULT_GOAL := help
.PHONY: help
.SILENT:

GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)
KEY    := $(shell date +%s | sha256sum | base64 | head -c 32 ; echo)

APPDIR="application/"
MY_VAR=$(shell echo whatever)

run: docker-up
stop: docker-down

build: install docker-up migrate create-admin

update: pull install docker-up
	docker-compose exec php-fpm php artisan app:update

install: clone
	@cd $(APPDIR) && $(MAKE) install

install-dev: clone
	@cd $(APPDIR) && $(MAKE) install-dev

clone:
	@if [ ! -e ./$(APPDIR) ]; then \
		git clone https://github.com/REBELinBLUE/deployer $(APPDIR); \
		cp phpdocker/laravel_env ./$(APPDIR)/.env; \
	fi

pull: clone
	@cd $(APPDIR) && git pull

status:
	docker-compose ps

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down

generate-key:
	@sed -i "s/JWT_SECRET=changeme/JWT_SECRET=${KEY}/g" $(APPDIR)/.env
	@docker-compose exec php-fpm php artisan key:generate --force

create-admin:
	docker-compose exec php-fpm php artisan deployer:create-user admin admin@example.com changeme --no-email

migrate:
	docker-compose exec php-fpm php artisan migrate

clean: docker-stop
	@cd $(APPDIR) && $(MAKE) clean

## Prints this help
help:
	@echo "\nUsage: make ${YELLOW}<target>${RESET}\n\nThe following targets are available:\n"
	@awk -v skip=1 \
		'/^##/ { sub(/^[#[:blank:]]*/, "", $$0); doc_h=$$0; doc=""; skip=0; next } \
		 skip  { next } \
		 /^#/  { doc=doc "\n" substr($$0, 2); next } \
		 /:/   { sub(/:.*/, "", $$0); printf "  ${YELLOW}%-30s${GREEN}%s${RESET} %s\n", $$0, doc_h, doc; skip=1 }' \
		$(MAKEFILE_LIST)
