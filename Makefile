all :
				cd srcs && \
				docker-compose up --build

build :
				cd srcs && \
				docker-compose build

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

clear_data :
				sudo rm -rf /home/mavi/data/mariadb_data/* && sudo rm -rf /home/mavi/data/wordpress_data/* 

clean : rip clear_data
				docker system prune -af --volumes

logs :
				cd srcs && \
				docker-compose logs

ls :
				echo "\033[1;37mContainers\033[0m-------------------------------------------------------------" && \
				docker ps -a && \
				echo "\033[1;37mImages\033[0m-----------------------------------------------------------------" && \
				docker image ls && \
				echo "\033[1;37mVolumes\033[0m----------------------------------------------------------------" && \
				docker volume ls && \
				echo "\033[1;37mNetworks\033[0m---------------------------------------------------------------" && \
				docker network ls && \
				echo "\033[1;37mHost-Volumes\033[0m-----------------------------------------------------------" && \
				cd ../../data/mariadb_data/ && ls -l && cd ../wordpress_data && ls -l
.SILENT: