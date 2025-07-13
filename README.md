# Name

docker-perl-starman-sms-send-webservice

# Docker Image

This Docker image is built from the AlmaLinux 9 Docker Image

# Starman

[Starman](https://metacpan.org/release/Starman) is a high-performance preforking [PSGI/Plack](https://metacpan.org/release/Plack) web server.

# SMS::Send

The DockerFile installs SMS::Send from DavisNetworks yum repo.

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
