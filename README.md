# dokuwiki-docker

This doesn't really work as a pre-built container as you need to make site-specific changes to httpd.conf.

To build, you will need to download:

Dockuwiki: 
  http://download.dokuwiki.org/out/dokuwiki-d9556fbc2c1c07a0baaf81c07d4165f6.tgz

PHP:
  http://php.net/get/php-5.6.12.tar.bz2/from/a/mirror
 

Default httpd.conf assumes ssl (change httpd.conf if you like)

To generate a self-signed cert for your server:

openssl req -new -x509 -nodes -out server.pem -keyout server.key -days 3650 -subj '/CN=admin-wiki.rosalind.compute.estate'

More notes on ssl setup at http://www.microhowto.info/howto/create_a_self_signed_ssl_certificate.html 
