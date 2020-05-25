FROM wordpress:php7.2-apache
MAINTAINER Jonas Plitt version: 0.1
USER root

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils
    
RUN apt install -y software-properties-common

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        libbz2-dev \
        libmemcached-dev \
        libmariadb-dev \
        libsasl2-dev \
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
    " \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y $buildDeps $runtimeDeps \
    #&& docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mcrypt mysql mysqli pdo_mysql pdo_pgsql pgsql soap xsl zip sockets
    && docker-php-ext-install pdo_mysql yaml zip bz2
    #&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    #&& docker-php-ext-install gd \
    #&& docker-php-ext-install exif \
    #&& pecl install memcached-2.2.0 redis-4.3.0 zendopcache \
    #&& docker-php-ext-enable memcached.so redis.so opcache.so \
    #&& apt-get purge -y --auto-remove $buildDeps \
    #&& rm -r /var/lib/apt/lists/* \
    #&& a2enmod rewrite

#RUN add-apt-repository -y ppa:ondrej/apache2

#RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list \
#    && curl https://packages.sury.org/php/apt.gpg | apt-key add - \
#    && apt-get update -qq \
#    && DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2 php7.2-common php7.2-cli \
#    php7.2-mysql php7.2-curl php7.2-xml php7.2-mbstring \
#    php7.2-intl php7.2-redis php7.2-zip \
#    
#RUN && docker-php-ext-install bcmath bz2 calendar iconv intl mbstring mcrypt mysql mysqli pdo_mysql pdo_pgsql pgsql soap xsl zip sockets \
    
#VOLUME /var/www/html
#COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
