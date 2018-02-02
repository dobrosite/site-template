FROM mysql:5.7

ARG FILE_OWNER_UID=1000
RUN usermod --uid ${FILE_OWNER_UID} mysql
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
