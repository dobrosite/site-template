## UID пользователя, которому должны принадлежать созадваемые Docker файлы.
FILE_OWNER_UID := $(shell id -u)

## Файл конфигурации docker-compose.
DOCKER_COMPOSE_FILE = docker-compose.dev.yml

## Команда docker-compose.
docker-compose = env FILE_OWNER_UID=$(FILE_OWNER_UID) docker-compose --file $(DOCKER_COMPOSE_FILE) $(1)

.PHONY: start
start: ## Запускает контейнеры Docker.
	$(call docker-compose,up -d --build)

.PHONY: stop
stop: ## Останавливает контейнеры Docker.
	$(call docker-compose,down)

.PHONY: restart
restart: stop start ## Перезапускает контейнеры Docker.

.PHONY: docker-clean
docker-clean: ## Удаляет созданные Docker файлы.
	$(call docker-compose,down)
	-rm -rf develop/docker/db/var

.PHONY: docker-init-db
docker-init-db: db/database.sql  ## Загружает в БД дамп из db/database.sql.
	$(call docker-compose,exec db sh -c "mysql --user=local --password=local local < /var/dumps/database.sql")

db/database.sql:
	$(MAKE) db-dump REMOTE=test
