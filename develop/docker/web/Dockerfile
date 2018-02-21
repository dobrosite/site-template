# Версия PHP по умолчанию (можно поменять в файле .env).
ARG DOCKER_PHP_VERSION=7.0
FROM php:${DOCKER_PHP_VERSION}-apache
# Для версией PHP, которые уже официально не поддерживаются, закомментируйте предыдущий FROM и
# раскомментируйте этот:
#FROM alterway/php:${DOCKER_PHP_VERSION}-apache

##
## Установка разных полезных пакетов.
##
RUN apt-get update && apt-get install -y wget

##
## Установка расширений PHP.
## Набор расширений можно поменять в файле .env
##
ARG DOCKER_PHP_EXTENSIONS="iconv mbstring mysqli pdo_mysql tokenizer"

# Для расширения curl нужен сам cURL.
RUN if [ "${DOCKER_PHP_EXTENSIONS#*curl}" != "${DOCKER_PHP_EXTENSIONS}" ]; then \
        apt-get update && apt-get install -y libcurl3-dev; \
    fi

# Для gd нужны дополнительные библиотеки.
RUN if [ "${DOCKER_PHP_EXTENSIONS#*gd}" != "${DOCKER_PHP_EXTENSIONS}" ]; then \
        apt-get update && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
        && docker-php-ext-configure gd \
            --with-freetype-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/; \
    fi

## Установка стандартных расширений.
RUN for extension in ${DOCKER_PHP_EXTENSIONS}; do \
        if php -m | grep "^${extension}$" > /dev/null; then \
            echo "${extension} PHP extension already installed."; \
        else \
            docker-php-ext-install ${extension}; \
        fi; \
    done

## Устанавливаем xdebug.
RUN pecl channel-update pecl.php.net
RUN if [ $(php -r 'echo PHP_MAJOR_VERSION;') -lt 7 ]; then \
        if [ $(php -r 'echo PHP_MINOR_VERSION;') -lt 4 ]; then \
            pecl install --force xdebug-2.2.7; \
        elif [ $(php -r 'echo PHP_MINOR_VERSION;') -lt 5 ]; then \
            pecl install --force xdebug-2.4.1; \
        else \
            pecl install --force xdebug-2.5.5; \
        fi; \
    else \
        pecl install --force xdebug; \
    fi
RUN docker-php-ext-enable xdebug

# Устанавливаем Composer.
RUN wget https://getcomposer.org/installer -O - -q | php -- --force --install-dir=/usr/local/bin --filename=composer

# Включаем нужные модули Apache (можно поменять в файле .env).
ARG DOCKER_APACHE_MODULES="expires headers rewrite"
RUN if [ "${DOCKER_APACHE_MODULES}" != "" ]; then \
        a2enmod ${DOCKER_APACHE_MODULES}; \
    fi

# Образы alterway/php не создают ссылку самостоятельно, делаем это вручную.
RUN if [ ! -e /etc/apache2/sites-enabled/000-default.conf ]; then \
        ln -s /etc/apache2/sites-available/000-default.conf \
            /etc/apache2/sites-enabled/000-default.conf; \
    fi

# Файлы, создаваемые веб-сервером, должны быть доступны для изменения вне контейнера.
ARG FILE_OWNER_UID=1000
RUN if id www-data; then \
		usermod --uid ${FILE_OWNER_UID} --shell /bin/sh www-data; \
	else \
		useradd --system --uid ${FILE_OWNER_UID} --user-group --no-create-home www-data; \
	fi

ENV APACHE_RUN_USER www-data
