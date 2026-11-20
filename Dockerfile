ARG VERSION_PREFIX=""
FROM php:${VERSION_PREFIX}cli-alpine AS build

## Install SSH
RUN apk add --no-cache openssh-client

## Install Composer, Deployer and remove unneeded files
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN set -eux; \
    composer --prefer-dist --no-ansi --no-interaction --no-progress global require deployer/deployer; \
    composer clear-cache; \
    rm -rf /tmp/pear /usr/src/* /usr/local/include/php /usr/local/php \
        /usr/local/lib/php/build /usr/local/lib/php/doc /usr/local/lib/php/test \
        /usr/local/bin/php-cgi /usr/local/bin/phpdbg /usr/local/bin/phpize /usr/local/bin/php-config \
        /usr/local/bin/pecl /usr/local/bin/pear /usr/local/bin/peardev \
        /usr/local/bin/docker-php-ext-* /usr/local/bin/docker-php-source; \
    rmdir /var/www/html

## Smoke test
RUN set -eux; \
    php -m >/dev/null; \
    composer --version; \
    /root/.composer/vendor/bin/dep --version; \
    for tool in ssh ssh-agent ssh-add; do command -v "$tool"; done; \
    for tool in phpize pecl docker-php-ext-install php-cgi phpdbg; do \
        if command -v "$tool"; then echo "$tool must not be in the image" >&2; exit 1; fi; \
    done

## Single layer without the build-only files
FROM scratch
COPY --from=build / /
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Restore the environment, FROM scratch drops it
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PHP_INI_DIR=/usr/local/etc/php

## Set path
ENV PATH_BIN=/usr/bin

## Add Composer vendor into PATH
ENV COMPOSER_PATH=/root/.composer
ENV PATH=$COMPOSER_PATH/vendor/bin:$PATH

## Non-root user
## @todo: Gitlab SSH_PRIVATE_KEY: Operation not permitted
#USER nobody

## Custom workdir intefers with SSH known hosts
#WORKDIR /var/www

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
