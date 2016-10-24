# dokuwiki-docker

### TO BUILD:

Default httpd.conf assumes ssl (change httpd.conf if you like)

Then just docker build -t me/whatever .


### TO RUN:

Create a named volume for your data:

  docker volume create --name=dokuwiki-data

The server will also need SSL keys, so put them in a named volume too. For dev, you can just:

```
  docker run --name=deleteme -it -v dokuwiki-keys:/tmp cassj/dokuwiki /bin/bash
  cd /tmp
  openssl req -new -x509 -nodes -out server.pem -keyout server.key -days 3650 -subj '/CN=localhost'
  exit
  docker rm deleteme
``` 

Now you can start an instance of the actual web-server that will use the data volumes.  

```
  docker run --name=dokuwiki -d -p 80:80 -p 443:443 -e PORT=80 -e SSLPORT=443 -e ADMINEMAIL=whoever@example.com -e SERVERNAME=localhost -v dokuwiki-data:/data -v dokuwiki-keys:/usr/local/apache2/conf/dokuwiki-ssl cassj/dokuwiki:0.1
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


To upgrade your dokuwiki, backup your data volume then you can just grab the latest version of the container from dockerhub, stop your running container and start a new one with the same volumes. 
