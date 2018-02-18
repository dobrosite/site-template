# Версия PHP по умолчанию (можно поменять в файле .env).
ARG DOCKER_PHP_VERSION=7.0
FROM php:${DOCKER_PHP_VERSION}-apache
# Для версией PHP, которые уже официально не поддерживаются, закомментируйте предыдущий FROM и
# раскомментируйте этот:
#FROM alterway/php:${DOCKER_PHP_VERSION}-apache

# Устанавливаем требуемые расширения PHP (можно поменять в файле .env).
ARG DOCKER_PHP_EXTENSIONS="iconv mbstring mysqli pdo_mysql tokenizer"
RUN if [ "${DOCKER_PHP_EXTENSIONS}" != "" ]; then \
        if [ "${DOCKER_PHP_EXTENSIONS#*gd}" != "${DOCKER_PHP_EXTENSIONS}" ]; then \
            apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
            && docker-php-ext-configure gd \
                --with-freetype-dir=/usr/include/ \
                --with-jpeg-dir=/usr/include/; \
        fi; \
        docker-php-ext-install ${DOCKER_PHP_EXTENSIONS}; \
    fi

# Устанавливаем xdebug.
RUN pecl channel-update pecl.php.net
RUN if [ $(php -r 'echo PHP_MAJOR_VERSION;') -lt 7 ]; then \
        if [ $(php -r 'echo PHP_MINOR_VERSION;') -lt 4 ]; then \
            pecl install xdebug-2.2.7; \
        elif [ $(php -r 'echo PHP_MINOR_VERSION;') -lt 5 ]; then \
            pecl install xdebug-2.4.1; \
        else \
            pecl install xdebug-2.5.5; \
        fi; \
    else \
        pecl install xdebug; \
    fi
RUN docker-php-ext-enable xdebug

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
