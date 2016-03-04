# JSS Playground in Docker

Source: <https://github.com/macadmins/docker-jss>

Dockerfile by: [Nick McSpadden](https://github.com/nmcspadden)

## Docker images

* [Ubuntu](https://hub.docker.com/_/ubuntu/) (for data container)
* [MySQL](https://registry.hub.docker.com/_/mysql/)
* [Tomcat](https://hub.docker.com/_/tomcat/)

## Requirements

* Download JSS Manual Installation from JAMF Nation My Assets > My Products
* Download [JCE Unlimited Encryption](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html) files

## Setup

Clone this repo:

`$ git clone https://github.com/jlehikoinen/jss-playground.git`

Copy `ROOT.war` to `jss-playground`

Copy `US_export_policy.jar` and `local_policy.jar` to `jss-playground`

Edit `tomcatKeystore.sh` variables

Edit `keystorePass` in `server.xml`

## Build JSS Docker image

`$ cd jss-playground`

`$ docker build -t my-jss .`

Note that you might need to reboot the Docker host before building the image because of low entropy. More info [here](https://blog.pivotal.io/pivotal-cloud-foundry/features/challenges-with-randomness-in-multi-tenant-linux-container-platforms).

## Run containers with Docker Compose (2 options)

First make changes to yaml files if needed.

Run MySQL container and your custom JSS container:

`$ docker-compose up -d`

_OR_

Run MySQL container, your custom JSS container and import MySQL database. Before running this option, rename your database dump to `db.sql` and place it to the root of working dir:

`$ docker-compose -f docker-compose-import.yml up -d`

## Access JSS

Get Docker Machine (`default`) IP address if you're running Docker locally on your Mac:

`$ docker-machine ip default`

Go to URL: `https://<docker-machine IP address>:8443`

Log in with your JSS credentials

### JSS Setup Assistant (if no database was imported)

Select Edit Connection

**Edit Database Connection**

* Database Hostname: `<docker-machine IP address>` : `3306`
* Database: `jamfsoftware`
* Database Username: `jamfsoftware`
* Database Password: `jamfsw03`

Enter Activation Code and finish JSS Setup Assistant


## Run containers separately

### Data container

```
$ docker run -d \
--name mysql_data \
-v /var/lib/mysql \
ubuntu:15.10
```

### MySQL container

```
$ docker run -d \
--name mysql_app \
--volumes-from mysql_data \
-p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_DATABASE=jamfsoftware \
-e MYSQL_USER=jamfsoftware \
-e MYSQL_PASSWORD=jamfsw03 \
mysql:5.6
```

### JSS container

```
$ docker run -d \
--name jss \
--link mysql_app:mysql \
-p 8443:8443 \
my-jss
```

### Import MySQL database

`$ docker run -it --rm --link=mysql_app:mysql -v "$PWD":/tmp mysql:5.6 sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" "$MYSQL_ENV_MYSQL_DATABASE" < /tmp/db.sql'`

## After testing

Stop and delete all containers:

`$ docker stop $(docker ps -aq) && docker rm $(docker ps -aq)`
