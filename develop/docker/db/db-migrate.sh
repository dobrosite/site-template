#!/usr/bin/env bash

LOG_TABLE='docker_migrations'

while ! mysql --execute='' 2> /dev/null; do echo -n '.'; sleep 1; done;
echo ''

if ! mysql database -e 'SHOW TABLES' | grep ${LOG_TABLE} > /dev/null; then
    mysql database -e 'CREATE TABLE docker_migrations (migration VARCHAR(255) CHARACTER SET utf8 NOT NULL, PRIMARY KEY (migration))'
fi

for filename in $(ls -1 --hide=README.md /var/dumps/migrations/); do
    if mysql database -e "SELECT * FROM docker_migrations WHERE migration='${filename}'" | grep "${filename}" >/dev/null; then
       echo "${filename} — already applied"
    else
        if mysql database --verbose < /var/dumps/migrations/${filename}; then
            echo "${filename} — applying..."
            mysql database -e "INSERT INTO docker_migrations (migration) VALUES ('${filename}')"
        else
            exit 1
        fi
    fi
done
