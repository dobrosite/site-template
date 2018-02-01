# Локальная разработка с использованием Docker

Для локальной разработки вам потребуются:

- [Docker](https://docs.docker.com/install/) 1.10+;
- [Docker Compose](https://docs.docker.com/compose/install/) 1.6+;
- [GNU Make](make.md) (необязательно, см. [Работа с Docker без Make](#Работа-с-docker-без-make)).

**Обратите внимание: все приведённые здесь команды должны выполняться в корневой папке проекта!**

## Запуск сайта

Для запуска достаточно выполнить команду

    make start

Эта команда запустит службы:

- [http://localhost/](http://localhost/) — разрабатываемый сайт;
- [http://localhost:8080/](http://localhost8080/) — phpMyAdmin.

Если порт 80 или 8080 на `localhost` вашей машины уже занят, укажите свои значения при помощи переменных:

- `DS_SITE_PORT` — порт сайта;
- `DS_PMA_PORT` — порт phpMyAdmin.

Пример:

    make start DS_SITE_PORT=81 DS_PMA_PORT=82

## Остановка сайта

    make stop

## Работа с Docker без Make

Запуск контейнеров:

    env FILE_OWNER_UID=`id -u` docker-compose -f docker-compose.dev.yml up -d --build

Остановка контейнеров:

    docker-compose -f docker-compose.dev.yml down
