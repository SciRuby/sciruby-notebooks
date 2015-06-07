.PHONY: image
image:
	docker build -t sciruby .

.PHONY: run
run:
	docker run -d -p 8888:8888 sciruby

.PHONY: nuke
nuke:
	-docker stop `docker ps -aq`
	-docker rm -fv `docker ps -aq`
	-docker images -q --filter "dangling=true" | xargs docker rmi
