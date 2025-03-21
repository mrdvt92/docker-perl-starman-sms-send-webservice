IMAGE_NAME=local/perl-starman-sms-send-webservice
CONTAINER_NAME=sms-send-webservice

all:
	@echo "Syntax:"
	@echo "  make build   # builds the docker image from the Dockerfile as $(IMAGE_NAME)"
	@echo "  make run     # runs the docker image on http://127.0.0.1:5027/"
	@echo "  make rm      # stops and removes the image"
	@echo "  make bash    # executes a bash shell on the running container"

#ulimit hack from https://github.com/docker/buildx/issues/379#issuecomment-1274361933
build:	Dockerfile app.psgi
	docker build --progress=plain --tag=$(IMAGE_NAME) .

rebuild: build rm run
	@echo -n

run_no_mount:
	@echo "This option requires you to update SMS-Send.ini with your credintials and rebuild the image."
	docker run --detach --restart=unless-stopped --name $(CONTAINER_NAME) --publish 5027:5027 $(IMAGE_NAME)

run:
	@echo "This option requires you to have /etc/SMS-Send.ini with your credintials."
	docker run --detach --restart=unless-stopped --name $(CONTAINER_NAME) -v /etc/SMS-Send.ini:/etc/SMS-Send.ini --publish 5027:5027 $(IMAGE_NAME)

stop:
	docker stop $(CONTAINER_NAME)

rm:	stop
	docker rm $(CONTAINER_NAME)

bash:
	docker exec -it $(CONTAINER_NAME) /bin/bash && true

firewall:
	sudo firewall-cmd --zone=public --permanent --add-port=5027/tcp
	sudo firewall-cmd --reload

plackup:
	plackup app.psgi
