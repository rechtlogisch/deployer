ARG VERSION_PREFIX=""
FROM amd64/php:${VERSION_PREFIX}cli-alpine
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Set path
ENV PATH_BIN /usr/bin

## Install SSH
RUN apk add -q --no-cache openssh-client

## Copy scripts
COPY scripts/*.sh $PATH_BIN/

## Install Composer, Deployer and remove unneeded files
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
ARG VERSION_DEPLOYER="7.3"
RUN composer -q --prefer-dist --no-ansi --no-interaction --no-progress global require "deployer/deployer:^${VERSION_DEPLOYER}" && \
    rmdir /var/www/html

## Add Composer vendor into PATH
ENV COMPOSER_PATH /root/.composer
ENV PATH $COMPOSER_PATH/vendor/bin:$PATH

## When set, no output in Pipelines
#USER www-data

## Custom workdir intefers with SSH known hosts
#WORKDIR /var/www
