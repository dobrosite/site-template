Шаблон для разработки сайта
===========================

Системные требования
--------------------

1. Совместимая с [POSIX.2](https://ru.wikipedia.org/wiki/POSIX) операционная система.
2. Консольная команда `git`.

Как использовать
----------------

1. Создайте новый пустой проект в [git.dobro.site/sites](http://git.dobro.site/sites).
2. Клонируйте шаблон под именем сайта, который собираетесь разрабатывать (например, *example.com*):

    git clone --recursive git@git.dobro.site:dobrosite/site-template.git example.com

3. Перейдите в папку проекта и переключите его на адрес сайта в GitLab:

    cd example.com
    make REMOTE_REPO=git@git.dobro.site:sites/example.com

