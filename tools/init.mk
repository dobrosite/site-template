## Удаляет историю Git готовя шаблон к разработке нового сайта.
.PHONY: new-project
new-project:
	$(if $(REMOTE_REPO),,$(error Задайте URL проекта в git.dobro.site в переменной REMOTE_REPO))
	git checkout --orphan temp
	git add -A
	git commit -am 'Начало разработки сайта'
	git branch -D master
	git branch -m master
	git remote set-url origin $(REMOTE_REPO)
	git push -f origin master
