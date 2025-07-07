ARG VERSION_PREFIX=""
FROM php:${VERSION_PREFIX}cli-alpine
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Set path
ENV PATH_BIN=/usr/bin

## Install SSH
RUN apk add -q --no-cache openssh-client

## Install Composer, Deployer and remove unneeded files
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer -q --prefer-dist --no-ansi --no-interaction --no-progress global require deployer/deployer && \
    rmdir /var/www/html

## Add Composer vendor into PATH
ENV COMPOSER_PATH=/root/.composer
ENV PATH=$COMPOSER_PATH/vendor/bin:$PATH

## Non-root user
## @todo: Gitlab SSH_PRIVATE_KEY: Operation not permitted
#USER nobody

## Custom workdir intefers with SSH known hosts
#WORKDIR /var/www
