FROM debian:buster

RUN apt update -y

RUN apt install php-fpm php-mysql -y

RUN apt install curl -y

COPY /tools/script.sh /
COPY /conf/wp-config.php /

RUN chmod +x /script.sh

CMD ["/script.sh"]