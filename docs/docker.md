# Локальная разработка с использованием Docker

Для локальной разработки вам потребуются:

- [Docker](https://docs.docker.com/install/) 1.13+;
- [Docker Compose](https://docs.docker.com/compose/install/) 1.10+;

**Обратите внимание: все приведённые здесь команды должны выполняться в корневой папке проекта!**

## Краткая инструкция

Выполните команду

    make prepare start

После этого станут доступны:

- [http://localhost/](http://localhost/) — разрабатываемый сайт;
- [http://localhost:8080/](http://localhost8080/) — phpMyAdmin.

## Управление контейнерами

### С помощью GNU Make

Доступные команды:

- `make start` — запускает все контейнеры (при первом запуске производит все необходимые настройки);
- `make stop` — останавливает все контейнеры;
- `make restart` — перезапускает все контейнеры;
- `make docker-rebuild` — пересобирает все контейнеры.

### Работа без GNU Make

Запуск контейнеров:

    env FILE_OWNER_UID=`id -u` docker-compose -f docker-compose.dev.yml up -d --build

Остановка контейнеров:

    docker-compose -f docker-compose.dev.yml down

## Настройки

### Переменные окружения

Значения по умолчанию указаны в файле [.env](../.env). Вы можете изменить их там, задать в окружении
или указать в качестве аргумента make.

#### DOCKER_MYSQL_VERSION

Версия СУБД MySQL.

#### DOCKER_PMA_PORT

Задаёт порт на котором доступен phpMyAdmin.

#### DOCKER_SITE_PORT

Задаёт порт на котором доступен сайт.

#### DOCKER_PHP_VERSION

Используемая версия PHP. Т. к. используются
[официальные образы PHP](https://hub.docker.com/r/library/php/tags/), то выбрать можно только
[поддерживаемую версию](http://php.net/supported-versions.php).

#### DOCKER_PHP_EXTENSIONS

Список расширений PHP через пробел.
