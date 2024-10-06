FROM debian:bullseye
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server mariadb-client procps && \
    mkdir -p /var/run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql && \
    chmod 755 /var/run/mysqld && \
    chmod 770 /var/lib/mysql
EXPOSE 3306
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/setup_db.sh /usr/local/bin/setup_db.sh
RUN chmod +x /usr/local/bin/setup_db.sh
ENTRYPOINT ["bash", "/usr/local/bin/setup_db.sh"]
