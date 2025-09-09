FROM debian:11

# ENV DEBIAN_FRONTEND=noninteractive

# ENV MYSQL_ROOT_USER=my_root_user
# ENV MYSQL_ROOT_PASSWORD=myrootpassword

# ENV MYSQL_USER=mywpuser
# ENV MYSQL_DATABASE=wordpress
# ENV MYSQL_PASSWORD=mywppassword


RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN  rm -rf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["sh", "/setup.sh"]
CMD ["mysqld"]