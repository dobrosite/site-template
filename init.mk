## Меняем цель по умолчанию.
.DEFAULT_GOAL = init

## Готовит шаблон к разработке нового сайта.
.PHONY: init
init:
	$(if $(REMOTE_REPO),,$(error Переменная REMOTE_REPO должна содержать URL нового (пустого!) проекта на git.dobro.site))
	$(if $(shell git config user.name),,$(error Задайте своё имя с помощью "git config --global user.name"))
	$(if $(shell git config user.email),,$(error Задайте свой e-mail с помощью "git config --global user.email"))
	git checkout --orphan temp
	sed 's/example.com/$(SITE_DOMAIN)/' README.template.md > README.md
	-rm README.template.md
	git add -A
	-rm init.mk
	git commit -am 'Начало разработки сайта'
	git branch -D master
	git branch -m master
	git remote set-url origin $(REMOTE_REPO)
	git push -f origin master
	@echo
	@echo ЧТО ДЕЛАТЬ ДАЛЬШЕ
	@echo
	@echo Заполните README.md, указав CMS, системные требования, ссылки на документацию и т. п.
	@echo
