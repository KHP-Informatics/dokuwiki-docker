# dokuwiki-docker

### TO BUILD:

Default httpd.conf assumes ssl (change httpd.conf if you like)

Then just docker build -t me/whatever .


### TO RUN:

You probably want to keep your data in a volume so you can back stuff up.
create a data-only container. You should also load your ssl keys in at this point
Note to self - if you're using boot2docker, you'll need to copy the keys onto the boot2docker VM

```
    docker run --name=dokuwikidata \
    -v /tmp/server.pem:/usr/local/apache2/conf/server.pem \
    -v /tmp/server.key:/usr/local/apache2/conf/server.key \
    cassj/dokuwiki /bin/true
```

if you 

    docker inspect dokuwikidata

you'll see that the /var/www/dokuwiki directory is mapped to a host directory:

```
    "Volumes": {
        "/usr/local/apache2/conf/server.key": "/Volumes/KCL/docker/dokuwiki-docker/server.key",
        "/usr/local/apache2/conf/server.pem": "/Volumes/KCL/docker/dokuwiki-docker/server.pem",
        "[/var/www/dokuwiki]": "/mnt/sda1/var/lib/docker/vfs/dir/3202195e9e116662e267852197ec8a4003f16990234b314a3845c56f736bfadf"
    },
```

Now you can start an instance of the actual web-server that will use the data volumes.  

```
       docker run --name=dokuwiki  -p 80:80 -p 443:443 -d -e PORT=80  -e SSLPORT=443 \
       -e ADMINEMAIL=foo@bar.com -e SERVERNAME=localhost  --volumes-from dokuwikidata \
       cassj/dokuwiki
```


You need to provide some config settings as environment variables. These will be used in httpd.conf.
They're fairly self-explanatory and all optional. Defaults are:

PORT 80
SSLPORT 443
ADMINEMAIL root@localhost
SERVERNAME localhost

You will need an SSL cert for your server, which should be provided to the container by bind mounting as a volume.
You can generate a self signed cert something like:

openssl req -new -x509 -nodes -out server.pem -keyout server.key -days 3650 -subj '/CN=localhost'

More notes on ssl setup at http://www.microhowto.info/howto/create_a_self_signed_ssl_certificate.html


### BACKUP

If you want to backup your data, you could run something like the following, which would copy the entire contents of the /var/www/dokuwiki 
directory to the /tmp/bkup directory on the host. 

 
```
docker run --rm --volumes-from dokuwikidata -v /tmp/bkup:/bkup cassj/dokuwiki /usr/bin/rsync -avz /var/www/dokuwiki /bkup
```

If your server container fails, you should be able to just restart it with --volumes-from dokuwikidata. No mutable data is kept in the container.



