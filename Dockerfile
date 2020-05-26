FROM wordpress:php7.2-apache
MAINTAINER Jonas Plitt version: 1.0
USER root
VOLUME /var/www/html

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils

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
    && docker-php-ext-install pdo_mysql

RUN pecl channel-update pecl.php.net
RUN pecl install yaml-2.0.0 && docker-php-ext-enable yaml

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod ug+wx /entrypoint.sh && ls -lisah /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
