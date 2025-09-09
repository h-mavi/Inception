all :
				cd srcs && docker-compose up --build && docker-compose start

stop :
				cd srcs && docker-compose stop && docker-compose down

nginx :
				cd srcs/requirements/nginx && docker build -t nginx . && docker run -p 443:443 nginx

mariadb :
				cd srcs/requirements/mariadb && docker build -t mariadb . && docker run -p 3306:3306 mariadb

prune :
				docker system prune -af --volumes