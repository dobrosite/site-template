ARG DOCKER_PHP_EXTENSIONS
ARG DOCKER_PHP_VERSION
ARG FILE_OWNER_UID

FROM php:${DOCKER_PHP_VERSION}-apache

# Расширения PHP.
RUN apt-get update && docker-php-ext-install -j$(nproc) ${DOCKER_PHP_EXTENSIONS}

# Модули Apache.
RUN a2enmod rewrite

RUN useradd --system --uid ${FILE_OWNER_UID} --user-group --no-create-home www
ENV APACHE_RUN_USER www
ENV DEBUG_MODE on
