#!/bin/ash

echo "Starting PHP-FPM..."
/usr/sbin/php-fpm8 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "Starting Nginx..."
echo "=!=!=!== Please ignore the error about no permissions to the log file. ==!=!=!="
/usr/sbin/nginx -c /home/container/nginx/nginx.conf
