#-usa Debian come base image
FROM debian:11

RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /cert/nginx

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /cert/nginx/nginx.key -out /cert/nginx/nginx.crt \
  -subj "/C=IT/ST=Italy/L=Rome/O=42School/CN=localhost"
  #-subj "/C=IT/ST=Italy/L=Rome/O=42School/CN=mfanelli.42.fr"

RUN rm -f /etc/nginx/conf.d/default.conf
#RUN rm -f /etc/nginx/sites-enabled/default
#RUN rm -f /etc/nginx/sites-available/default

COPY default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/nginx

#COPY muahah.html /var/www/html/muahah.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]