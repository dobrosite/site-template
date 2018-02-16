# Версия PHP по умолчанию (можно поменять в файле .env).
ARG DOCKER_PHP_VERSION=7.0
FROM php:${DOCKER_PHP_VERSION}-apache
# Для версией PHP, которые уже официально не поддерживаются.
#FROM alterway/php:${DOCKER_PHP_VERSION}-apache

# Устанавливаем xdebug.
RUN pecl channel-update pecl.php.net
RUN if [ $(php -r 'echo PHP_MAJOR_VERSION;') -lt 7 ]; then \
        pecl install xdebug-2.5.5; \
    else \
        pecl install xdebug; \
    fi

RUN docker-php-ext-enable xdebug

# Устанавливаем требуемые расширения PHP (можно поменять в файле .env).
ARG DOCKER_PHP_EXTENSIONS="iconv mbstring mysqli pdo_mysql tokenizer"
RUN if [ "${DOCKER_PHP_EXTENSIONS}" != "" ]; then \
        apt-get update && docker-php-ext-install -j$(nproc) ${DOCKER_PHP_EXTENSIONS}; \
    fi

# Включаем нужные модули Apache (можно поменять в файле .env).
ARG DOCKER_APACHE_MODULES="expires headers rewrite"
RUN if [ "${DOCKER_APACHE_MODULES}" != "" ]; then \
        a2enmod ${DOCKER_APACHE_MODULES}; \
    fi

# Файлы, создаваемые веб-сервером, должны быть доступны для изменения вне контейнера.
ARG FILE_OWNER_UID=1000
RUN if id www-data; then \
		usermod --uid ${FILE_OWNER_UID} --shell /bin/sh www-data; \
	else \
		useradd --system --uid ${FILE_OWNER_UID} --user-group --no-create-home www-data; \
	fi

ENV APACHE_RUN_USER www-data
