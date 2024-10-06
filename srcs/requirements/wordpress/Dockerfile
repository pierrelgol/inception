FROM debian:bullseye
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y wget php7.4 php-fpm php-mysql redis php-redis mariadb-client \
                       default-mysql-client && \
    rm -rf /var/lib/apt/lists/*
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN wget https://fr.wordpress.org/wordpress-6.4.2-fr_FR.tar.gz -P /var/www/html && \
    tar -xzf /var/www/html/wordpress-6.4.2-fr_FR.tar.gz -C /var/www/html && \
    rm /var/www/html/wordpress-6.4.2-fr_FR.tar.gz
RUN chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress
EXPOSE 9000
COPY ./tools/setup_wp.sh /usr/local/bin/setup_wp.sh
RUN chmod +x /usr/local/bin/setup_wp.sh
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
WORKDIR /var/www/html/wordpress
ENTRYPOINT ["bash", "/usr/local/bin/setup_wp.sh"]
