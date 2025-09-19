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
				docker-compose down -v

rip : stop down

clean :
				docker system prune -af --volumes ; docker volume prune -af ; \
				sudo rm -rf /home/mavi/data/mariadb_data/* && sudo rm -rf /home/mavi/data/wordpress_data/* 

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
				cd ../../data/mariadb_data/ && ls -l && cd ../wordpress_data && ls -l
.SILENT: