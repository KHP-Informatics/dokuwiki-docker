#!/bin/sh

cd /tmp
wget "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
tar -xvzf dokuwiki-stable.tgz
rm dokuwiki-stable.tgz
mkdir -p /var/www/dokuwiki
mv dokuwiki*/* /var/www/dokuwiki/
rm -rf dokuwiki*
chown -R dokuwiki:dokuwiki /var/www/dokuwiki


