ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-fpm-alpine

# Nginx + tooling
RUN apk add --no-cache bash curl ca-certificates git unzip nginx tini

# PHP extensions (built-ins like ctype, curl, dom, fileinfo, mbstring, pdo, phar, simplexml, tokenizer, xml are already included)
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
        bcmath bz2 calendar exif gd gettext gmp intl mysqli opcache \
        pdo_mysql pdo_pgsql pdo_sqlite pdo_odbc pdo_dblib odbc \
        soap sockets xsl zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Backwards compatibility: start.sh on existing servers calls /usr/sbin/php-fpm8
RUN ln -s /usr/local/sbin/php-fpm /usr/sbin/php-fpm8 \
    && adduser -D -h /home/container container

USER container
ENV USER=container HOME=/home/container

WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["/bin/ash", "/entrypoint.sh"]
