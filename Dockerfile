FROM php:cli-alpine
LABEL maintainer="Recht logisch <https://rechtlogisch.de>"

## Install SSH
RUN apk add --no-cache \
    openssh-client

## Set home directory
ENV HOME /var/www

## Remove default directory
RUN rmdir $HOME/html

## Install Composer and Deployer with Recipes
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer --no-progress global require deployer/deployer && \
    composer --no-progress global require deployer/recipes --dev

## Add Composer vendor into PATH
ENV PATH $HOME/.composer/vendor/bin:$PATH

## Set user
USER www-data

## Set working directory
WORKDIR $HOME
