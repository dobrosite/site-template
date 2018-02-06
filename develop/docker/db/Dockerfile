ARG DOCKER_MYSQL_VERSION=5.7
FROM mysql:${DOCKER_MYSQL_VERSION}

ARG FILE_OWNER_UID=1000
RUN usermod --uid ${FILE_OWNER_UID} mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
