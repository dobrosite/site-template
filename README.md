# Шаблон для разработки сайта

## Системные требования

1. Совместимая с [POSIX.2](https://ru.wikipedia.org/wiki/POSIX) операционная система.
2. Консольная команда `git`.
3. [GNU Make](https://www.gnu.org/software/make/)

[Подробнее о требованиях и подготовке системы](https://github.com/dobrosite/site-template/wiki/requirements).

## Как использовать

Создайте новый пустой проект в [git.dobro.site/sites](http://git.dobro.site/sites).

Клонируйте шаблон под именем сайта, который собираетесь разрабатывать (например, *example.com*):

    git clone --recursive https://github.com/dobrosite/site-template.git example.com

Перейдите в папку проекта и переключите его на адрес сайта в GitLab:

    cd example.com
    make REMOTE_REPO=git@git.dobro.site:sites/example.com

## Документация

- [Структура проекта](doc/structure.md)
- [Сборка проекта с помощью GNU Make](doc/make.md)
- [Локальная разработка с использованием Docker](doc/docker.md)
