FROM httpd
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

RUN apt-get update && apt-get install -q -y php5 php5-gd vim curl libapache2-mod-php5 bzip2 gcc libapr1-dev libaprutil1-dev libxml2-dev build-essential rsync wget  && apt-get clean 

# Create a user & group (apache runs as this user)
RUN groupadd --system dokuwiki 
RUN useradd --system -g dokuwiki dokuwiki 

# Install PHP for this Apache
# Install PHP for this Apache
COPY install_php.sh /tmp/install_php.sh
RUN chmod +x /tmp/install_php.sh
RUN /tmp/install_php.sh

#COPY php-5.6.12.tar.bz2 /tmp/php-5.6.12.tar.bz2
#RUN cd /tmp && tar -xvjf php-5.6.12.tar.bz2
#RUN cd /tmp/php-5.6.12/ && ./configure --with-apxs2=/usr/local/apache2/bin/apxs  && make && make install

# PHP & Apache configuration
COPY php.ini /usr/local/lib/php.ini
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

## Install dokuwiki to a volume
COPY install_dokuwiki.sh /tmp/install_dokuwiki.sh
RUN chmod +x /tmp/install_dokuwiki.sh
RUN /tmp/install_dokuwiki.sh

#COPY dokuwiki.tgz /var/www/dokuwiki.tgz
#RUN cd /var/www && tar -xvzf dokuwiki.tgz && rm dokuwiki.tgz 
#RUN chown -R dokuwiki:dokuwiki /var/www/dokuwiki

VOLUME '/var/www/dokuwiki'

# http and httpd ports. You can map these to whatever host ports you want with -p
EXPOSE 80
EXPOSE 443

# Default env vars for httpd. You can override these at runtime if you want to
ENV SERVERNAME localhost
ENV ADMINEMAIL root@localhost



