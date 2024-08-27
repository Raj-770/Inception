FROM debian:buster

RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y mariadb-server mariadb-client && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

COPY ./conf/mariadb.cnf /etc/mysql/mariadb.conf.d/99-server.cnf

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

COPY ./tools/init_mariadb.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

EXPOSE 3306

CMD [ "/usr/local/bin/startup.sh" ]
