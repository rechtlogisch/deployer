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

## Remove build-only tools and the unused embed SAPI
## Keep /lib/apk/db (SBOM); libcurl stays (php links it) — only the curl CLI goes.
RUN set -eux; \
    apk del --no-network openssl tar xz curl; \
    apk del --no-network --purge apk-tools; \
    rm -rf /etc/apk /usr/share/apk /lib/apk/exec /usr/local/lib/libphp.so /usr/local/etc/php/php.ini-*

## Drop unused busybox applets; keep binary + allowlist for entrypoint, Composer, CI SSH setup
## Allowlist: sh ash unzip tr cat echo printf mkdir chmod rm cp mv ls env test [ [[ grep sed id whoami
RUN set -eux; \
    keep=' sh ash unzip tr cat echo printf mkdir chmod rm cp mv ls env test [ [[ grep sed id whoami '; \
    for d in /bin /sbin /usr/bin /usr/sbin; do \
        [ -d "$d" ] || continue; \
        for link in "$d"/*; do \
            [ -L "$link" ] || continue; \
            case "$(busybox readlink "$link")" in */busybox|/bin/busybox) ;; *) continue ;; esac; \
            name="${link##*/}"; \
            case "$keep" in *" $name "*) continue ;; esac; \
            rm -f "$link"; \
        done; \
    done; \
    rm -f /usr/bin/ssl_client

## Smoke test
RUN set -eux; \
    php -m >/dev/null; \
    composer --version; \
    /root/.composer/vendor/bin/dep --version; \
    php -r 'exit(file_get_contents("https://repo.packagist.org/packages.json") ? 0 : 1);'; \
    for t in ssh ssh-agent ssh-add ssh-keyscan ssh-keygen scp sh tr unzip; do command -v "$t"; done; \
    for tool in phpize pecl docker-php-ext-install php-cgi phpdbg apk openssl curl wget; do \
        if command -v "$tool"; then echo "$tool must not be in the image" >&2; exit 1; fi; \
    done; \
    if [ -e /usr/local/lib/libphp.so ]; then echo "libphp.so must not exist" >&2; exit 1; fi

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
