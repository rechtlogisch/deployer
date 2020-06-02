FROM php:7.4-cli-alpine

## Install SSH
RUN apk add --no-cache openssh-client

## Install Composer and Deployer with Recipes
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    composer global require hirak/prestissimo --no-plugins --no-scripts && \
    composer global require deployer/deployer && \
    composer global require deployer/recipes --dev

## Add Composer vendor into PATH
ENV PATH /root/.composer/vendor/bin:$PATH
