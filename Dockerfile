FROM httpd
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

RUN apt-get update && apt-get install -q -y  vim curl openssl libssl-dev pkg-config libpng12-0 libpng12-dev libldap-2.4-2 libldap2-dev bzip2 gcc libapr1-dev libaprutil1-dev libxml2-dev build-essential rsync wget && apt-get clean 

# Create a user & group (apache runs as this user)
RUN groupadd --system dokuwiki 
RUN useradd --system -g dokuwiki dokuwiki 

# Install PHP for this Apache
COPY install_php.sh /tmp/install_php.sh
RUN chmod +x /tmp/install_php.sh
RUN /tmp/install_php.sh

## PHP & Apache configuration
COPY php.ini /usr/local/lib/php.ini
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
RUN mkdir /usr/local/apache2/conf/dokuwiki-ssl
#VOLUME '/usr/local/apache2/conf/dokuwiki-ssl'

## Install dokuwiki to a volume
RUN mkdir -p /var/www/html
COPY install_dokuwiki.sh /tmp/install_dokuwiki.sh
RUN chmod +x /tmp/install_dokuwiki.sh
RUN /tmp/install_dokuwiki.sh

#VOLUME '/var/www/dokuwiki'

# http and httpd ports. You can map these to whatever host ports you want with -p
EXPOSE 80
EXPOSE 443

# Default env vars for httpd. You can override these at runtime if you want to
ENV SERVERNAME localhost
ENV ADMINEMAIL root@localhost



