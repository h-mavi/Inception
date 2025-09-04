## 1. Use Debian as the base image
FROM debian:11

## 2. Install Nginx and clean up
RUN apt-get update \
	&& apt-get install -y nginx \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## 3. Create the directory for Nginx runtime files
RUN mkdir -p /run/nginx

## 4. Copy our simple index.html to the default Nginx web root
COPY index.html /var/www/html/index.html

## 5. Expose port 80 so we can access Nginx from the browser
EXPOSE 80

## 6. Start Nginx in the foreground (so Docker keeps running)
CMD ["nginx", "-g", "daemon off;"]