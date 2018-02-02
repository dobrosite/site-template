ARG DOCKER_PHP_VERSION=7.0
FROM php:${DOCKER_PHP_VERSION}-apache

# Расширения PHP.
ARG DOCKER_PHP_EXTENSIONS="mbstring pdo_mysql tokenizer iconv mysqli"
RUN apt-get update && docker-php-ext-install -j$(nproc) ${DOCKER_PHP_EXTENSIONS}

# Модули Apache.
RUN a2enmod rewrite

ARG FILE_OWNER_UID=1000
RUN useradd --system --uid ${FILE_OWNER_UID} --user-group --no-create-home www

ENV APACHE_RUN_USER www
ENV DEBUG_MODE on
