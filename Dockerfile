FROM httpd
MAINTAINER Cass Johnston <cassjohnston@gmail.com>

RUN apt-get update && apt-get install -q -y php5 php5-gd vim curl libapache2-mod-php5 bzip2 gcc libapr1-dev libaprutil1-dev libxml2-dev build-essential 

RUN groupadd --system dokuwiki 
RUN useradd --system -g dokuwiki dokuwiki 

COPY php-5.6.12.tar.bz2 /tmp/php-5.6.12.tar.bz2
RUN cd /tmp && tar -xvjf php-5.6.12.tar.bz2
RUN cd /tmp/php-5.6.12/ && ./configure --with-apxs2=/usr/local/apache2/bin/apxs  && make && make install

COPY php.ini /usr/local/lib/php.ini
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
COPY httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY server.pem /usr/local/apache2/conf/server.pem
COPY server.key /usr/local/apache2/conf/server.key

COPY dokuwiki.tgz /var/www/dokuwiki.tgz
RUN cd /var/www && tar -xvzf dokuwiki.tgz && rm dokuwiki.tgz 
RUN chown -R dokuwiki:dokuwiki /var/www/dokuwiki

EXPOSE 80
EXPOSE 443


#RUN rm -rf /var/www/html
#RUN mv /var/www/dokuwiki /var/www/html

#RUN chown -R www-data:www-data /var/www/html
#
#CMD ["/usr/bin/supervisord"]




