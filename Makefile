
# Подключаем локальные настройки сборки, если они есть.
ifneq ($(realpath Makefile.local),)
include Makefile.local
endif

# Подключаем нужные библиотеки, если dev-tools установлены.
ifneq ($(realpath develop/dev-tools/make),)
include develop/dev-tools/make/common.mk
include develop/dev-tools/make/npm.mk
## Папка с composer.json
COMPOSER_ROOT_DIR := $(PUBLIC_DIR)
include develop/dev-tools/make/composer.mk
include develop/dev-tools/make/remote.mk
include develop/dev-tools/make/db.mk
#include develop/dev-tools/make/wordpress.mk
endif

# Эта часть нужна только для начальной подготовки шаблона, после чего её можно удалить.
ifneq ($(realpath init.mk),)
include init.mk
endif


## Папка клиентских ресурсов.
assets_dir=$(PUBLIC_DIR)

.PHONY: build
build: ## Собирает изменившиеся файлы (цель по умолчанию).
# Цель prepare должна выполняться в отдельном процессе, чтобы после неё Makefile мог быть
# перечитан заново для подключения установленных библиотек.
	$(MAKE) prepare
# Если есть файл composer.json, но нет папки vendor, выполняем «composer install».
ifneq ($(and $(realpath $(composer.json)), $(if $(realpath $(COMPOSER_VENDOR_DIR)),,1)),)
	$(MAKE) composer-install
endif
#	$(MAKE) scripts styles

## Подключаем цели Docker.
# Делаем это после цели build, чтобы, если dev-tools не установлены, именно build была целью по умолчанию.
include develop/docker/docker.mk

.PHONY: clean
clean: ## Очищает проект от артефактов сборки.
	$(MAKE) docker-clean
	$(MAKE) npm-clean
	$(MAKE) composer-clean

.PHONY: update
update: ## Обновляет зависимости проекта.
	cd develop/dev-tools && git pull
ifneq ($(realpath node_modules),)
	$(MAKE) npm-update
endif
	$(MAKE) composer-update

## Готовит проект и окружение к сборке.
.PHONY: prepare
prepare: develop/dev-tools/.git

## Устанавливает dev-tools.
develop/dev-tools/.git:
	git submodule init
	git submodule update

#.PHONY: scripts
#scripts: $(uglifyjs) ## Собирает сценарии.
#	$(call run-uglifyjs,$(assets_dir)/bundle.js,$(assets_dir)/bundle.min.js)
#
#.PHONY: styles
#styles: $(sass) ## Собирает стили.
#	$(call run-sass,$(assets_dir)/bundle.scss,$(assets_dir))
