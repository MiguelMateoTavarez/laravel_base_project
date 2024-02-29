FROM php:fpm-alpine3.18

ENV PHPGROUP=miguelmateo
ENV PHPUSER=miguelmateo

RUN adduser -g ${PHPGROUP} -s /bin/sh -D ${PHPUSER}

RUN sed -i "s/user = www-data/user = ${PHPUSER}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = ${PHPGROUP}/g" /usr/local/etc/php-fpm.d/www.conf

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN chown -R ${PHPUSER}:${PHPUSER} /var/www/html
RUN chmod -R 755 /var/www/html

RUN apk add curl

RUN curl -sSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o - | sh -s \
      \pdo_pgsql @composer-2.7.1

EXPOSE 9000

CMD [ "php-fpm",  "-y", "/usr/local/etc/php-fpm.conf", "-R" ]
