FROM ubuntu

ENV TERM=linux

RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" > /etc/apt/sources.list.d/ondrej-php.list \
	&& echo "deb http://ppa.launchpad.net/ondrej/php-qa/ubuntu xenial main" > /etc/apt/sources.list.d/ondrej-php-qa.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
	&& apt-get update \
	&& apt-get -y remove php5.6 \
	&& apt-get -y autoremove \
	&& apt-get -y --no-install-recommends install ca-certificates \
		php7.1-cli php7.1-mbstring php7.1-mysql php7.1-sqlite3 php-apcu php-apcu-bc \
		php7.1-json \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

WORKDIR "/application"

CMD ["php", "artisan", "queue:work", "--queue=deployer-default", "--sleep=3", "--tries=1"]
