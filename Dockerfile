FROM debian:buster

# UPDATE
RUN apt-get update
RUN apt-get upgrade -y

# INSTALL
RUN apt-get install -y nginx default-mysql-server
RUN apt-get install -y php php-curl php-mysql php-fpm php-mbstring 
RUN apt-get install -y wget
RUN apt-get install -y vim

# CONFIG
COPY ./srcs/key ./key
COPY ./srcs/default ./etc/nginx/sites-available/default
COPY ./srcs/wp-config.php ./var/www/html/wordpress/wp-config.php
COPY ./srcs/config.inc.php ./var/www/html/phpmyadmin/config.inc.php

# INSTALL MORE
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz  
RUN tar -xvf phpMyAdmin-4.9.5-all-languages.tar.gz --strip-components 1 -C /var/www/html/phpmyadmin  

# WORDPRESS INSTALL
RUN wget -c https://wordpress.org/latest.tar.gz  
RUN tar -xvf latest.tar.gz --strip-components 1 -C /var/www/html/wordpress

# ALLOW NGINX USER
RUN chown -R www-data:www-data /var/www/*
RUN chmod -R 755 /var/www/*

# MYSQL LOGIN & SERVICE START
CMD service mysql start && mysql --execute "CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';CREATE DATABASE ft_server;GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';FLUSH PRIVILEGES;";\
	service nginx start;\
	service php7.3-fpm start;\
	sleep inf;
