# Name

docker-centos7-perl-starman-sms-send-webservice

# Docker Image

This Docker image is built from the [Official CentOS 7 Docker Image](https://hub.docker.com/_/centos).

# Starman

[Starman](https://metacpan.org/release/Starman) is a high-performance preforking [PSGI/Plack](https://metacpan.org/release/Plack) web server. We install it with `yum` from RPMs at [OpenFusion](http://repo.openfusion.net/centos7-x86_64/)

# SMS::Send

We install SMS::Send with `yum` from RPMs at DavisNetworks.

# PSGI App

The PSGI App `app.psgi` is saved inside the Docker image as `/app/app.psgi`.

# SMS-Send.ini

The INI Configuration file is either saved in the container or mounted from the container.

# Dependencies

Dependencies to run the PSGI app inside the container are installed in the Dockerfile. 

# Docker Build Command

```
$ make build
```

# Docker Run Command

```
$ make run
```
