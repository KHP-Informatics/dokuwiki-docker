# dokuwiki-docker

### TO BUILD:

Default httpd.conf assumes ssl (change httpd.conf if you like)

Then just docker build -t me/whatever .


### TO RUN:

Put your SSL cert in a named volume. For dev, you can just:

```
  docker run --name=deleteme -it -v dokuwiki-keys:/tmp cassj/dokuwiki /bin/bash
  cd /tmp
  openssl req -new -x509 -nodes -out server.pem -keyout server.key -days 3650 -subj '/CN=localhost'
  exit
  docker rm deleteme
``` 
Docker 1.9 recommends using named volumes, but until 1.10 (https://github.com/docker/docker/issues/18670) these don't copy over the data from the container image as anonymous volumes did. To work around this for now, create a named data volume by manually copying over the contents:

```
docker run --name=deleteme -it -v dokuwiki-data:/data cassj/dokuwiki:0.1 /usr/bin/rsync -avz /var/www/dokuwiki/ /data/ 
docker rm deleteme
```

Now you can start an instance of the actual web-server that will use the data volumes. 

```
  docker run --name=dokuwiki -d -p 80:80 -p 443:443 -e PORT=80 -e SSLPORT=443 -e ADMINEMAIL=whoever@example.com -e SERVERNAME=localhost -v dokuwiki-data:/var/www/dokuwiki -v dokuwiki-keys:/usr/local/apache2/conf/ssl-certs --log-opt max-size=2m --log-opt max-file=3  cassj/dokuwiki:0.1
```

You need to provide some config settings as environment variables. These will be used in httpd.conf.
They're fairly self-explanatory and all optional. Defaults are:

```
PORT 80
SSLPORT 443
ADMINEMAIL root@localhost
SERVERNAME localhost
```

Once your container is running, go to <host>/install.php to complete the installation and set up an admin user 


### To Upgrade

Notes on upgrading dokuwiki can be found here - https://www.dokuwiki.org/install:upgrade. They basically amount to overwriting the existing php files with the new ones and letting dokuwiki's upgrade process do the rest. To do this with this container, do somethign like: 

Backup your volumes. 

Pull the latest version of the container image from dockerhub

Stop your running container

Mount the named volume to a temporary location and copy over the updates: 

```
docker run --name=deleteme -it -v dokuwiki-data:/data cassj/dokuwiki /usr/bin/rsync -avz /var/www/dokuwiki/ /data/
docker rm deleteme
``` 

And then start a new instance of the container with the updated volume:

```
docker run --name=dokuwiki -d -p 80:80 -p 443:443 -e PORT=80 -e SSLPORT=443 -e ADMINEMAIL=whoever@example.com -e SERVERNAME=localhost -v dokuwiki-data:/var/www/dokuwiki -v dokuwiki-keys:/usr/local/apache2/conf/dokuwiki-ssl --log-opt max-size=2m --log-opt max-file=3 cassj/dokuwiki:0.1
```







