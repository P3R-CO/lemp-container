#!/bin/bash
ln -s /etc/nginx /config
ln -s /etc/php /config
ln -s /var/lib/mysql /config
/usr/sbin/php-fpm7.3
/usr/sbin/nginx
tail -f /dev/null