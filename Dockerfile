FROM php:cli-alpine
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Set home directory
ENV HOME /var/www

## Install SSH
RUN apk add --no-cache \
    openssh-client

## Install Composer, Deployer with Recipes and remove unneeded files
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer --no-progress global require deployer/deployer && \
    composer --no-progress global require deployer/recipes --dev && \
    rmdir $HOME/html

## Add Composer vendor into PATH
ENV PATH $HOME/.composer/vendor/bin:$PATH

## When set, no output in Pipelines
#USER www-data

## Set working directory
WORKDIR $HOME
