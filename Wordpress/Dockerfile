FROM wordpress:php7.2-apache
USER root

# Get Debian up-to-date
RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y git \
    wget curl \
    ca-certificates lsb-release apt-transport-https gnupg bsdmainutils

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list \
    && curl https://packages.sury.org/php/apt.gpg | apt-key add - \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y php7.2 php7.2-common php7.2-cli \
    php7.2-mysql php7.2-curl php7.2-xml php7.2-mbstring \
    php7.2-intl php7.2-redis php7.2-zip \
    
VOLUME /var/www/html
COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
