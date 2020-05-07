FROM debian:latest
MAINTAINER Poseidon's 3 Rings
ENV APP_NAME="P3R LEMP Stack"

WORKDIR /usr/src/P3R

RUN apt-get update && apt-get -y install \
	nginx \
	mariadb-server \
	mariadb-client \
	expect

CMD systemctl stop nginx.service \
	&& systemctl start nginx.service \
	&& systemctl enable nginx.service \
	&& systemctl stop mariadb.service \
	&& systemctl start mariadb.service \
	&& systemctl enable mariadb.service

COPY mysql_secure.exp .
CMD expect mysql_secure.exp
RUN apt-get -y purge expect \
	&& apt-get -y autoremove

RUN apt-get -y install \
	php-fpm \
	php-common \
	php-mbstring \
	php-xmlrpc \
	php-soap \
	php-gd \
	php-xml \
	php-intl \
	php-mysql \
	php-cli \
	php-zip \
	php-curl
	
COPY php.ini /etc/php/7.3/fpm/php.ini

COPY www/* /var/www/html/
COPY default /etc/nginx/sites-available/
CMD systemctl stop php7.3-fpm.service \
	&& systemctl start php7.3-fpm.service \
	&& systemctl enable php7.3-fpm.service \
	&& systemctl stop nginx.service \
	&& systemctl start nginx.service \
	&& systemctl enable nginx.service \
	&& systemctl stop mariadb.service \
	&& systemctl start mariadb.service \
	&& systemctl enable mariadb.service

RUN mkdir -p /run/php/ \
	&& mkdir -p /config/
COPY startup.sh .
RUN chmod +x startup.sh
CMD ./startup.sh
#END of LEMP Build