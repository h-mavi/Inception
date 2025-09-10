#-usa Debian come base image
FROM debian:11

#-RUN esegue i comandi durante il processo di creazione dell'image
#-obv apt-get update è per l'update, mentre il resto è per installare
# nginx. Le flag -y è per eviate che chieda dei prompt allo user (setta 
# tutte le risposte necessarie per il download a yes).
#-' apt-get clean ' fa la stessa cosa in pratica, levando file temporanei
# non più necessari
#-' rm -rf /var/lib/apt/lists/ ' serve per eliminare il cached dei pacchetti
# delle liste dei file, in modo da ridurre il size dell'image.
RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#mi creo una directory dove salvarmi i certificati
#                               RUN mkdir -p /etc/nginx/certs?
RUN mkdir -p /cert/nginx

#creo i certificiati per usare la porta 443 :
# [openssl req] : inizia il processo per creare una richiesta (req) di certificato
# [-x509] : indica a OpenSSL di creare un certificato auto-firmato invece che una richiesta di firmare un certificato
# [-nodes] : indica a OpenSSL di non incriptare la private key (almeno Nginx può usarla auto.)
# [-days 365] : certificato valido per 365 giorni
# [-newkey rsa:2048] : genera una nuova RSA private key lunga 2048 bits
# [-keyout /cert/nginx/nginx.key] : indica il path dove salvare la private key
# [-out /cert/nginx/nginx.crt] : // // il certificato
# [-subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"] : da le info. sul soggetto per il certificato (country, state, city, organization, and common name).

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /cert/nginx/nginx.key -out /cert/nginx/nginx.crt \
  -subj "/C=IT/ST=Italy/L=Rome/O=42School/CN=mfanelli.42.fr"

#per ora basta il primo
RUN rm -f /etc/nginx/conf.d/default.conf
#RUN rm -f /etc/nginx/sites-enabled/default
#RUN rm -f /etc/nginx/sites-available/default

#aggiugo la mia configurazione personalizzata per dire NGIXN di usare la porta
# 443 con i certificati dati e i protocolli TLSv1.3
#-differenza tra TLSv1.2 e TLSv1.3 =
# TLSv1.2 è una versione più vecchia e quindi supportata ovunque, ma è più lenta e ha
# un "handshake" (la fase iniziale di negoziazione della connessione sicura) più complesso
# TLSv1.3 invece è 10 anni più recente, usa criptografie più moderne e sicure, rimuove vecchie
# features e protocolli insicuri. Visto che usaremo servizi aggiornati ai tempi modern per ora
# uso TLSv1.3
COPY default.conf /etc/nginx/conf.d/default.conf

#-run/nginx serve per contenere i file di runtime di nginx (come i file pid e i socket)
#-flag -p per mkdir è per fare in modo che se la partent directory non esiste
# venga creata lo stesso (The -p flag in mkdir -p /run/nginx means "create parent
# directories as needed." If run doesn't exist, it will be created automatically.
# Without -p, mkdir would fail if any parent directory is missing.)
RUN mkdir -p /run/nginx

#-copia index.html alla root di default di Nginx
#COPY index.html /var/www/html/index.html

#-espone la porta 443 così da accedere a Nginx dal browser (la port deve però essere 443, ma per ora non
# è accessibile perché la porta 443 è di default per HTTPS e richede un certificato SSL. Inoltre le
# le configurazioni di default di Nginx rimangono in ascolto solo sulla porta 80, quindi prima c'è anche
# ma aggiornare quello.)
EXPOSE 443

#-fa partire Nginx nel foreground (così Docker continua a girare)
# A farlo girare nel foreground è la flag -d nel comando per far
# partire il container (docker run -d -p 443:443 mynginx)
CMD ["nginx", "-g", "daemon off;"]