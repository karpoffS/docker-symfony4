FROM php:7.1-fpm
ARG TIMEZONE

RUN apt-get update && apt-get install -y git unzip openssl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "%s"\n', ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini

# Install PDO extensions
RUN docker-php-ext-install pdo pdo_mysql

# Install PHPUnit
RUN composer global require "phpunit/phpunit"
RUN ln -s /root/.composer/vendor/bin/phpunit /usr/bin/phpunit

# Create an alias for Symfony3 console
RUN echo 'alias symfony="php bin/console"' >> ~/.bashrc

WORKDIR /var/www/symfony
