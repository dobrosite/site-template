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

## Контейнер для которого надо выполнить действие (если цель подразумевает выбор контейнера).
SERVICE = web

## Команда docker-compose.
docker-compose = env FILE_OWNER_UID=$(FILE_OWNER_UID) docker-compose --file $(DOCKER_COMPOSE_FILE) $(1)

####
## Выполняет команду оболочки в контейнере.
##
## @param $(1) Команда, которую надо выполнить.
## @param $(2) Контейнер. По умолчанию $(SERVICE).
## @param $(3) Пользователь, от чьего имени выполнить команду.
##
docker-exec = $(call docker-compose,exec $(if $(3),--user $(3),) $(if $(2),$(2),$(SERVICE)) $(1))


.PHONY: start
start: ## Запускает контейнеры Docker.
	$(call docker-compose,up -d)
	$(call docker-compose,exec db db-migrate.sh)
	$(MAKE) $(.DEFAULT_GOAL)

.PHONY: stop
stop: ## Останавливает контейнеры Docker.
	$(call docker-compose,down)

.PHONY: restart
restart: stop start ## Перезапускает контейнеры Docker.

.PHONY: docker-build
docker-build: ## Собирает контейнеры Docker.
	$(call docker-compose,build)

.PHONY: docker-clean
docker-clean: ## Удаляет созданные Docker файлы.
	$(call docker-compose,down --rmi all --volumes --remove-orphans)
	-rm -rf $(DB_DATA_DIR)

.PHONY: docker-logs
docker-logs: ## Выводит в реальном времени журналы контейнеров.
	$(call docker-compose,logs --follow)

.PHONY: shell
shell: ## Запускает оболочку внутри указанного контейнера (по умолчанию в web).
	$(call docker-exec,bash)
