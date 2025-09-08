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
    && apt-get install -y wget tar \
    && apt-get install -y php php-fpm php-mysql php-cli php-curl php-gd php-xml php-mbstring \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#-scarichiamo la versione 6.8 di wordpress e la salviamo in '/tmp/wordpress.tar.gz' nel
# container
#-estraiamo il contenuto dell'archivio nella directory '/var/www/html
#-rimuoviamo l'archivio scaricato per liberare spazio
RUN wget https://wordpress.org/wordpress-6.8.tar.gz -O /tmp/wordpress.tar.gz \
    && tar -xzf /tmp/wordpress.tar.gz -C /var/www/html \
    && rm /tmp/wordpress.tar.gz

WORKDIR /var/www/html/

RUN chown -R www-data:www-data /var/www/html/

EXPOSE 9000

#-php-fpm7.4 -F : avvia php-fpm in foreground (l'opzione -F è per fare in modo che
# il processo rimanga in foreground, necessario per Docker per mantenere il container attivo)
CMD ["php-fpm7.4", "-F"]