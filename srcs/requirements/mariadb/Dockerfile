FROM debian:11

# ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#mariadb-client 

#RUN mkdir -p /var/lib/mysql

RUN  rm -rf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=5 \
        CMD [ 'mysqladmin ping -u root -p"${MYSQL_ROOT_PASSWORD}" || exit 1' ]

ENTRYPOINT ["sh", "/setup.sh"]
CMD ["mysqld"]