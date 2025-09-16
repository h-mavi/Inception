FROM debian:11

RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
#mariadb-client 

RUN  rm -rf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
#+x rende il file/dir eseguibile

EXPOSE 3306

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=5 \
        CMD [ 'mysqladmin ping -u root -p"${MYSQL_ROOT_PASSWORD}" || exit 1' ]

ENTRYPOINT ["sh", "/setup.sh"]
CMD ["mysqld"]


#This Dockerfile snippet configures how containers built from the image will start. The ENTRYPOINT instruction sets the main command that will always run when the container starts. Here, it specifies that the shell (sh) should execute the /setup.sh script. This script typically performs setup tasks, such as configuring environment variables, initializing files, or preparing services before the main application runs.
#The CMD instruction provides default arguments to the ENTRYPOINT. In this case, ["mysqld"] is passed as an argument to the shell script. If /setup.sh is written to forward its arguments (for example, by using $@ in the script), it will start the MySQL server (mysqld) after completing its setup steps. If you run the container without specifying a command, it will execute /setup.sh mysqld. If you provide a different command when running the container, that command will override the default CMD but still be passed to /setup.sh.
#This pattern is useful for containers that need custom initialization before launching the main service. A common 'gotcha' is forgetting to forward arguments in the shell script, which would prevent mysqld from starting as intended.