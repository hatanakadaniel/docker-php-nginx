#!/bin/sh

# Update nginx to match worker_processes to no. of cpu's
procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

# Always chown webroot for better mounting
#chown -Rf nginx:nginx /usr/share/nginx/html

#ls -la /usr/local/etc/
#ls -la /usr/local/etc/php
#which php-fpm

# Start supervisord and services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf