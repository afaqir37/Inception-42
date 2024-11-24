FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install -y mariadb-server

RUN mkdir -p /var/run/mysqld \ 
	&& chown -R root:root /var/run/mysqld \
	&& chmod 777 /var/run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 3306

ENTRYPOINT ["/script.sh"]
