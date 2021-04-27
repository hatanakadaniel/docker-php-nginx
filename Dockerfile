FROM php:8-fpm-buster

RUN apt update \
    && apt install -y gnupg2 apt-transport-https wget lsb-release python-pip python-setuptools htop vim \
    && \
        NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
    	  found=''; \
    	  for server in \
    		  ha.pool.sks-keyservers.net \
    		  hkp://keyserver.ubuntu.com:80 \
    		  hkp://p80.pool.sks-keyservers.net:80 \
    		  pgp.mit.edu \
    	  ; do \
    		  echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
    		  apt-key adv --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
    	  done; \
        test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
        echo "deb http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list \
RUN apt update

RUN pip install wheel supervisor supervisor-stdout
RUN apt install -y nginx

COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisord.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh
WORKDIR /var/php-fpm
EXPOSE 80
ENTRYPOINT ["/start.sh"]