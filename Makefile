all :
				cd src && docker-compose up --build

nginx :
				cd srcs/requirements/nginx && docker build -t nginx . && docker run -d -p 443:443 nginx

prune :
				docker system prune -af --volumes