all :
				cd srcs && \
				docker-compose up --build && docker-compose start

run :
				cd srcs && \
				docker-compose start ; make stop
stop :
				cd srcs && \
				docker-compose stop && docker-compose down

nginx :
				cd srcs/requirements/nginx && \
				docker build -t nginx . && docker run -p 443:443 nginx

mariadb :
				cd srcs/requirements/mariadb && \
				docker build -t mariadb . && docker run -p 3306:3306 mariadb

clean :
				docker system prune -af --volumes && docker volume rm srcs_mariadb_data srcs_wordpress_data

ls :
				docker ps && \
				echo "-----------------------------------------------------------------------" && \
				docker image ls && \
				echo "-----------------------------------------------------------------------" && \
				docker volume ls

.SILENT: