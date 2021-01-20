FROM php:8-fpm-alpine

ARG PHP_EXTENSIONS="pdo_pgsql zip"
ARG PHP_PECL_EXTENSIONS="xdebug mcrypt"
ARG PHP_BUILD_DEPS="${PHPIZE_DEPS} postgresql-dev libzip-dev libmcrypt-dev"
ARG PHP_EXT_DEPS="libmcrypt libpq libzip"

RUN apk update \
    && apk add --no-cache --virtual .build-deps $PHP_BUILD_DEPS \
    && apk add --no-cache $PHP_EXT_DEPS \
    && docker-php-source extract \
    && docker-php-ext-install -j$(nproc) $PHP_EXTENSIONS \
    && pecl install $PHP_PECL_EXTENSIONS \
    # && docker-php-ext-enable $PHP_EXTENSIONS \
    && docker-php-ext-enable $PHP_PECL_EXTENSIONS \
    && docker-php-source delete \
    && rm -rf /tmp/pear ~/.pearrc \
    #&& rm /usr/src/php.tar.* && rm /usr/local/bin/phpdbg \
    && rm -rf /var/cache/apk \
    && apk del --no-cache --purge .build-deps

# Configure Xdebug
# RUN    echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.log=/var/log/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#     && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini;

# Install composer
# RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

EXPOSE 9000

CMD ["php-fpm", "-FR"]
# php-fpm php-fpm -FR