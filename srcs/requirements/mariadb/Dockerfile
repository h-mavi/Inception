FROM debian:bullseye-slim

RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
#+x rende il file/dir eseguibile

EXPOSE 3306

ENTRYPOINT ["sh", "/setup.sh"]
CMD ["mysqld"]