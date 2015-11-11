#!/bin/sh

cd /tmp
wget "http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz"
tar -xvzf dokuwiki-stable.tgz
for f in dokuwiki*; do mv $f /var/www/dokuwiki; done
chown -R dokuwiki:dokuwiki /var/www/dokuwiki

rm -rf /tmp/*

