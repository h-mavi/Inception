all :
				cd srcs && \
				docker-compose up --build && docker-compose start

build :
				cd srcs && \
				docker-compose up --build

run :
				cd srcs && \
				docker-compose start

stop :
				cd srcs && \
				docker-compose stop

down :
				cd srcs && \
				docker-compose down

rip : stop down

# nginx :
# 				cd srcs/requirements/nginx && \
# 				docker build -t nginx . && docker run -p 443:443 nginx

# mariadb :
# 				cd srcs/requirements/mariadb && \
# 				docker build -t mariadb . && docker run -p 3306:3306 mariadb

clean :
				docker system prune -af --volumes && docker volume rm srcs_mariadb_data srcs_wordpress_data

logs :
				cd srcs && \
				docker-compose logs

ls :
				docker ps -a && \
				echo "-----------------------------------------------------------------------" && \
				docker image ls && \
				echo "-----------------------------------------------------------------------" && \
				docker volume ls && \
				echo "-----------------------------------------------------------------------" && \
				docker network ls && \
				echo "-----------------------------------------------------------------------" && \
				docker context ls
.SILENT:

#debain 11 e debian bullseye-slim sono la stessa cosa, per una versione più
# leggere si può usare debian:bullseye-slim
#continua a non funzionare sempre, e c'e' da sistemare la cosa dell'url
#fonti : https://www.digitalocean.com/community/tutorials/nginx-rewrite-url-rules