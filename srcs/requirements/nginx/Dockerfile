FROM debian:buster

RUN apt -y update && apt -y upgrade && apt install -y nginx vim curl

RUN apt -y install openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=login.42.fr/UID=login"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

COPY tools/index.html /var/www/html

CMD [ "nginx", "-g", "daemon off;" ]