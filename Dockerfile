ARG VERSION_PREFIX=""
FROM php:${VERSION_PREFIX}cli-alpine AS build

## Install SSH
RUN apk add --no-cache openssh-client

## Install Deployer via Composer (build-only); keep vendor for SBOM package versions
## deploy:vendors runs composer on the REMOTE host (recipe/deploy/vendors.php), not here.
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN set -eux; \
    composer --prefer-dist --no-ansi --no-interaction --no-progress global require deployer/deployer; \
    composer global dump-autoload --optimize --classmap-authoritative --no-ansi --no-interaction; \
    ## Prune vendor fluff; keep deployer recipe/ and contrib/
    find /root/.composer/vendor -type d \( -iname test -o -iname tests -o -name .github -o -name docs \) -prune -exec rm -rf {} +; \
    find /root/.composer/vendor -type f -name '*.md' ! -path '*/deployer/deployer/recipe/*' ! -path '*/deployer/deployer/contrib/*' -delete; \
    composer clear-cache; \
    rm -rf /root/.composer/cache /tmp/composer /tmp/pear; \
    ## Composer itself is not needed at runtime
    rm -f /usr/local/bin/composer

## Strip PHP build/dev leftovers (extensions are compiled in)
RUN set -eux; \
    rm -rf /tmp/pear /usr/src/* /usr/local/include/php /usr/local/php \
        /usr/local/lib/php/build /usr/local/lib/php/doc /usr/local/lib/php/test \
        /usr/local/bin/php-cgi /usr/local/bin/phpdbg /usr/local/bin/phpize /usr/local/bin/php-config \
        /usr/local/bin/pecl /usr/local/bin/pear /usr/local/bin/peardev \
        /usr/local/bin/docker-php-ext-* /usr/local/bin/docker-php-source; \
    ## Keep only compiled extensions under /usr/local/lib/php
    find /usr/local/lib/php -mindepth 1 -maxdepth 1 ! -name extensions -exec rm -rf {} +; \
    rmdir /var/www/html 2>/dev/null || true

## Drop unused OpenSSH tools; libedit is only linked by sftp
RUN set -eux; \
    rm -f /usr/bin/sftp /usr/bin/ssh-keygen /usr/bin/ssh-copy-id /usr/bin/ssh-pkcs11-helper; \
    rm -f /usr/lib/libedit.so* /usr/lib/*/libedit.so* 2>/dev/null || true; \
    rm -rf /usr/share/man /usr/share/doc /usr/share/misc /usr/share/udhcpc /usr/share/terminfo \
        /usr/share/apk /var/cache/apk /tmp/*; \
    ## Verify shared libs still resolve (before busybox applet prune removes ldd)
    ! ldd /usr/local/bin/php | grep 'not found'; \
    ! ldd /usr/bin/ssh | grep 'not found'; \
    ! ldd /usr/bin/ssh-agent | grep 'not found'; \
    ! ldd /usr/bin/scp | grep 'not found'

## Remove build-only tools and the unused embed SAPI
## Keep /lib/apk/db (SBOM); libcurl stays (php links it) — only the curl CLI goes.
RUN set -eux; \
    apk del --no-network openssl tar xz curl; \
    apk del --no-network --purge apk-tools; \
    rm -rf /etc/apk /usr/share/apk /lib/apk/exec /usr/local/lib/libphp.so /usr/local/etc/php/php.ini-*

## Drop unused busybox applets; keep binary + allowlist for entrypoint, unzip, CI SSH setup
## Allowlist: sh ash unzip tr cat echo printf mkdir chmod rm cp mv ls env test [ [[ grep sed id whoami
## /bin/bash is a tiny sh-wrapper so Deployer runLocally() (default: bash -s) works (busybox has no bash applet)
RUN set -eux; \
    printf '%s\n' '#!/bin/sh' 'exec /bin/sh "$@"' > /bin/bash; \
    chmod +x /bin/bash; \
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
    /root/.composer/vendor/bin/dep --version; \
    /root/.composer/vendor/bin/dep list >/dev/null; \
    ## runLocally uses bash -s by default
    bash -c 'echo runLocally-ok' | grep -q runLocally-ok; \
    printf '%s\n' 'echo from-stdin' | bash -s | grep -q from-stdin; \
    php -r 'exit(file_get_contents("https://repo.packagist.org/packages.json") ? 0 : 1);'; \
    for t in ssh ssh-agent ssh-add ssh-keyscan scp sh bash tr unzip; do command -v "$t"; done; \
    for tool in composer phpize pecl docker-php-ext-install php-cgi phpdbg apk openssl curl wget sftp ssh-keygen; do \
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

## Deployer vendor bin on PATH (Composer is not in the image)
ENV COMPOSER_PATH=/root/.composer
ENV PATH=$COMPOSER_PATH/vendor/bin:$PATH

## Skip Deployer telemetry (src/Command/CommandCommon.php)
ENV DO_NOT_TRACK=true

## Non-root user
## @todo: Gitlab SSH_PRIVATE_KEY: Operation not permitted
#USER nobody

## Custom workdir intefers with SSH known hosts
#WORKDIR /var/www

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php", "-a"]
