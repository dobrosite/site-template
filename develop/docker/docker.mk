## UID пользователя, которому должны принадлежать созадваемые Docker файлы.
FILE_OWNER_UID := $(shell id -u)

## Файл конфигурации docker-compose.
DOCKER_COMPOSE_FILE = docker-compose.dev.yml

## Папка с файлами БД.
DB_DATA_DIR = develop/docker/db/var

## Имя пользователя СУБД.
DB_USER = user

## Пароль пользователя СУБД.
DB_PASSWORD = password

## Имя БД.
DB_NAME = database

## Команда docker-compose.
docker-compose = env FILE_OWNER_UID=$(FILE_OWNER_UID) docker-compose --file $(DOCKER_COMPOSE_FILE) $(1)

## Команда mysql.
mysql = mysql --user=$(DB_USER) --password=$(DB_PASSWORD)

.PHONY: start
start: ## Запускает контейнеры Docker.
	$(call docker-compose,up -d)
ifeq ($(realpath $(DB_DATA_DIR)),)
	$(call docker-compose,exec db sh -c "while ! $(mysql) --execute='' 2> /dev/null; do echo -n '.'; sleep 1; done; echo")
	$(MAKE) docker-init-db
endif
	$(MAKE) $(.DEFAULT_GOAL)

.PHONY: stop
stop: ## Останавливает контейнеры Docker.
	$(call docker-compose,down)

.PHONY: restart
restart: stop start ## Перезапускает контейнеры Docker.

.PHONY: docker-rebuild
docker-rebuild: ## Пересобирает контейнеры Docker.
	$(call docker-compose,build)

.PHONY: docker-clean
docker-clean: ## Удаляет созданные Docker файлы.
	$(call docker-compose,down --remove-orphans)
	-rm -rf $(DB_DATA_DIR)

.PHONY: docker-init-db
docker-init-db: ## Загружает в БД дамп из db/database.sql.
	$(call docker-compose,exec db sh -c "$(mysql) $(DB_NAME) < /var/dumps/database.sql")
