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
    && docker-php-ext-enable $PHP_PECL_EXTENSIONS \
    && docker-php-source delete \
    && rm -rf /tmp/pear ~/.pearrc \
    && rm -rf /var/cache/apk \
    && apk del --no-cache --purge .build-deps

EXPOSE 9000

CMD ["php-fpm", "-FR"]