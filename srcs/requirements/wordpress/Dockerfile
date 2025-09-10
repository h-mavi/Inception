FROM debian:11

#-aggiorniamo tutto prima di installare
#-installiamo wget (un utility per scaricare file da internet)
#  e tar (strumento per estrarre e creare archivi) per scaricare e estrarre wordpress
#-installiamo php poichè wp è scritto in php e ci serve per installarlo,
# mentre php-fpm (FastCGI Process Manager) è un implementazione di php oer gestire
# le richieste web in modo più efficiente.
#-php-mysql per permettere a php di interagire con mysql (necessario per wp)
#-php-cli per eseguire script php dalla linea di comando
#-php-curl per permettere a php di fare richieste http
#-php-gd per la manipolazione delle immagini (usanto da wp)
#-php-xml per il parsing di file xml (usato da wp)
#-php-mbstring per la gestione di stringhe multibyte
RUN apt-get update \
    && apt-get install -y wget tar curl vim openssl mariadb-client \
    && apt-get install -y php php-fpm php-mysql php-cli php-curl php-gd php-xml php-mbstring \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#????????????????????????
RUN sed -i 's|listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp cli update

RUN mkdir -p /run/php

COPY ./tools/setup_test.sh /
RUN chmod +x /setup_test.sh
WORKDIR /var/www/html/

EXPOSE 9000

ENTRYPOINT [ "sh" , "/setup_test.sh" ]

#RUN chown -R www-data:www-data /var/www/html/
#RUN chmod -R 755 /var/www/html/