#!/bin/bash

echo "Starting PHP-FPM..."
/usr/sbin/php-fpm8 --fpm-config /home/container/php-fpm/php-fpm.conf --daemonize

echo "Starting Nginx..."
/usr/sbin/nginx -c /home/container/nginx/nginx.conf
