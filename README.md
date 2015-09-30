# dokuwiki-docker

TO BUILD:

You will need to download:

Dockuwiki: 
  http://download.dokuwiki.org/out/dokuwiki-d9556fbc2c1c07a0baaf81c07d4165f6.tgz

PHP:
  http://php.net/get/php-5.6.12.tar.bz2/from/a/mirror
 
Default httpd.conf assumes ssl (change httpd.conf if you like)


TO RUN


docker run -p 80:80 -p 443:443 -d -e PORT=80  -e ADMINEMAIL=foo@bar.com  -v /host/path/server.pem:/usr/local/apache2/conf/server.pem -v /host/path/server.key:/usr/local/apache2/conf/server.key  cassj/dokuwiki


You need to provide some config settings as environment variables. These will be used in httpd.conf.
They're fairly self-explanatory and all optional. Defaults are:

PORT 80
ADMINEMAIL root@localhost
SERVERNAME localhost

You will need an SSL cert for your server, which should be provided to the container by bind mounting as a volume.
You can generate a self signed cert something like:

openssl req -new -x509 -nodes -out server.pem -keyout server.key -days 3650 -subj '/CN=whatever.example.com'

More notes on ssl setup at http://www.microhowto.info/howto/create_a_self_signed_ssl_certificate.html


 
