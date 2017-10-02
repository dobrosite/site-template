prod_proto = ftp
prod_ftp_host = ftp.example.com
prod_ftp_user = user
prod_ftp_password = password
prod_ftp_root = /
prod_http_root = http://example.com/
prod_db_host = localhost:3306
prod_db_name = example
prod_db_user = user
prod_db_password = password

test_http_root = http://example.com.dobrotest.site
test_db_name = example
test_db_user = user
test_db_password = password

## Папка с composer.json
COMPOSER_ROOT := htdocs

## Папка темы оформления.
theme_dir := htdocs/themes/customized

##
## Собирает проект.
##
.PHONY: build
build: tools/dev-tools/.git
	$(MAKE) all

##
## Собирает все цели проекта.
##
.PHONY: all
all: scripts styles

##
## Устанавливает dev-tools.
##
tools/dev-tools/.git:
	git submodule init
	git submodule update

ifneq (,$(realpath tools/dev-tools/make))
# Подключаем нужные библиотеки.
include tools/dev-tools/make/common.mk
include tools/dev-tools/make/remote.mk
include tools/dev-tools/make/db.mk
endif

##
## Собирает сценарии.
##
.PHONY: scripts
scripts: $(uglifyjs)
	$(call run-uglifyjs,$(theme_dir)/main.js,$(theme_dir)/main.min.js)

##
## Собирает стили.
##
.PHONY: styles
styles: $(sass)
	$(call run-sass,$(theme_dir)/bundle.scss,$(theme_dir)/bundle.css)
