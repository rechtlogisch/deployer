ARG VERSION_PREFIX=""
FROM amd64/php:${VERSION_PREFIX}cli-alpine
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Set path
ENV PATH_BIN /usr/bin

## Install SSH
RUN apk add -q --no-cache openssh-client

## Copy scripts
COPY scripts/*.sh $PATH_BIN/

## Install Composer, Deployer with Recipes and remove unneeded files
ARG VERSION_DEPLOYER="7.0.0-beta.11"
RUN composer-install.sh && \
    composer -q --prefer-dist --no-ansi --no-interaction --no-progress global require "deployer/deployer:^${VERSION_DEPLOYER}" && \
    rmdir /var/www/html

## Add Composer vendor into PATH
ENV PATH /root/.composer/vendor/bin:$PATH

## When set, no output in Pipelines
#USER www-data

## Custom workdir intefers with SSH known hosts
#WORKDIR /var/www
