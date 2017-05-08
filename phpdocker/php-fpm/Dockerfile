FROM phpdockerio/php71-fpm:latest

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y remove php5.6 \
    && apt-get -y autoremove \
    && apt-get -y --no-install-recommends install php7.1-fpm php7.1-cli php7.1-mysql php7.1-sqlite3 php7.1-readline \
                                                  php7.1-gd php7.1-curl php7.1-mbstring php7.1-phpdbg \
                                                  php-xhprof php-xdebug \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* \
    && curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    rm ./composer-setup.php

WORKDIR "/application"
