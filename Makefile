SHELL := /bin/bash

.PHONY: build clean

proj_name := trans-imit
image_name := $(proj_name)
user_me := $$(whoami)
user_uid := $$(id -u)
user_gid := $$(id -g)
cont_name := $(proj_name)-serve

build:
	docker build -t $(image_name) \
		-f ./docker/Dockerfile \
		--build-arg USER_ME=$(user_me) \
		--build-arg USER_UID=$(user_uid) \
		--build-arg USER_GID=$(user_gid) \
		.
	docker image prune --force

serve:
	nvidia-docker run -ti --init \
		--name $(cont_name) \
		--hostname="palau-docker" \
		--network="host" \
	    -v ${HOME}/projects/$(proj_name):/workspace/$(proj_name) \
	    -v ${HOME}/projects/extern:/workspace/extern \
	    -v ${HOME}/data/$(proj_name):/workspace/data:ro \
	    -v ${HOME}/data/$(proj_name)/output:/workspace/output \
	    -v ${HOME}/data:/workspace/data-ext:ro \
		-p 5902:5902 -p 8888:8888 -p 6006:6006 \
		-e USER=$(user_me) \
	    -w /workspace \
	    $(image_name) bash

debug:
	nvidia-docker run -ti --rm --init \
		--name $(cont_name) \
		--hostname="palau-docker" \
		--network="host" \
		-v ${HOME}/projects/$(proj_name):/workspace/$(proj_name) \
	    -v ${HOME}/projects/extern:/workspace/extern \
	    -v ${HOME}/data/$(proj_name):/workspace/data:ro \
	    -v ${HOME}/data/$(proj_name)/output:/workspace/output \
	    -v ${HOME}/data:/workspace/data-ext:ro \
		-p 5902:5902 -p 8888:8888 -p 6006:6006 \
		-e USER=$(user_me) \
		--privileged \
	    -w /workspace \
	    $(image_name) bash

reattach:
	docker start $(cont_name)
	docker attach $(cont_name)

# inspect:
# 	docker start $(cont_name)
# 	nvidia-docker exec -ti \
# 		-e USER=$(user_me) \
# 		--user $$(id -u):$$(id -g) \
# 	    -w /workspace \
# 	    $(cont_name) bash
# # --entrypoint "/bin/bash" \

inspect:
	docker start $(cont_name)
	nvidia-docker exec -ti \
		-e USER="root" \
		-e HOME="/root" \
		--user 0 \
	    -w /workspace \
		$(cont_name) bash

clean:
	docker stop $(cont_name)
	docker rm $(cont_name)

own-this:
	sudo chown -R $(user_uid):$(user_gid) ./

cmake-build:
	#./scripts/build_extern.sh "$(proj_name)"
	#./scripts/build_cmake.sh
	./scripts/build_deepimit.sh $(proj_name)
