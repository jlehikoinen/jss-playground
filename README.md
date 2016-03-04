# JSS Playground in Docker

Source: <https://github.com/macadmins/docker-jss>

Dockerfile by: [Nick McSpadden](https://github.com/nmcspadden)

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

## Run containers with Docker Compose

`$ docker-compose up -d`

## Import MySQL database

`$ docker-compose -f docker-compose-import.yml up -d`

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

## JSS Setup Assistant

Get Docker Machine (`default`) IP address if running locally on Mac:

`$ docker-machine ip default`

URL: `https://<ip-address>:8443`

Select Edit Connection

* Database Hostname: `<docker-machine ip>` : `3306`
* Database: `jamfsoftware`
* Database Username: `jamfsoftware`
* Database Password: `jamfsw03`

Enter Activation Code and finish JSS Setup Assistant.
