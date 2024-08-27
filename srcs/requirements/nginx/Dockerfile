FROM debian:buster

RUN apt -y update && apt -y upgrade && apt install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=DE/ST=Baden Wurttemberg/L=Heilbronn/O=42 Heilbronn/CN=rpambhar.42.fr"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]