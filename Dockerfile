FROM wordpress:php7.2-apache
MAINTAINER Jonas Plitt version: 0.2
USER root
VOLUME /var/www/html

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils
    
#RUN apt install -y software-properties-common libyaml-dev

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        libbz2-dev \
        libmemcached-dev \
        libmariadb-dev \
        libsasl2-dev \
        gcc \
        make \
        autoconf \
        libc-dev \
        pkg-config \
        software-properties-common \
    " \
    runtimeDeps=" \
        curl \
        git \
        zip unzip \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libmcrypt-dev \
        libmemcachedutil2 \
        #libpng12-dev \
        libpq-dev \
        libxml2-dev \
        libxslt1-dev \
        libyaml-dev \
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    #&& docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mcrypt mysql mysqli pdo_mysql pdo_pgsql pgsql soap xsl zip sockets
    && docker-php-ext-install pdo_mysql

RUN pecl channel-update pecl.php.net
RUN pecl install yaml-2.0.0 && docker-php-ext-enable yaml

#VOLUME /var/www/html
COPY docker-entrypoint.sh /entrypoint.sh
#RUN ls -lisah .
RUN chmod ug+wx /entrypoint.sh && ls -lisah /
#RUN ls -lisah /var/www/html
#RUN find . -name docker-entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
#ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
