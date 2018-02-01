
# Подключаем локальные настройки сборки.
ifneq ($(realpath Makefile.local),)
include Makefile.local
endif

## Папка темы оформления.
theme_dir := htdocs/themes/customized

ifneq ($(realpath develop/dev-tools/make),)
# Подключаем нужные библиотеки.
include develop/dev-tools/make/common.mk
#include develop/dev-tools/make/npm.mk
## Папка с composer.json
COMPOSER_ROOT_DIR := $(PUBLIC_DIR)
#include develop/dev-tools/make/composer.mk
include develop/dev-tools/make/remote.mk
include develop/dev-tools/make/db.mk
#include develop/dev-tools/make/wordpress.mk
endif

include develop/docker/docker.mk

ifneq ($(realpath init.mk),)
include init.mk
endif

.PHONY: build
build: ## Собирает изменившиеся файлы (цель по умолчанию).
	$(MAKE) prepare
#	$(MAKE) scripts styles

## Готовит проект и окружение к сборке.
.PHONY: prepare
prepare: develop/dev-tools/.git

#.PHONY: scripts
#scripts: $(uglifyjs) ## Собирает сценарии.
#	$(call run-uglifyjs,$(theme_dir)/main.js,$(theme_dir)/main.min.js)
#
#.PHONY: styles
#styles: $(sass) ## Собирает стили.
#	$(call run-sass,$(theme_dir)/bundle.scss,$(theme_dir)/bundle.css)

## Устанавливает dev-tools.
develop/dev-tools/.git:
	git submodule init
	git submodule update
