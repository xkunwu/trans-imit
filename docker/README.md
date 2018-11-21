export PROJECT_NAME=trans-imit

## build the image from the docker file
docker build -t ${PROJECT_NAME}-tf-py3 -f ./docker/Dockerfile .

## get container running
nvidia-docker run -ti \
    --name ${PROJECT_NAME} \
    -v ${HOME}/projects/${PROJECT_NAME}/code:/workspace/code \
    -v ${HOME}/projects/extern:/workspace/code-ext \
    -v ${HOME}/data/${PROJECT_NAME}:/workspace/data:ro \
    -v ${HOME}/data/${PROJECT_NAME}/output:/workspace/output \
    -v ${HOME}/data:/workspace/data-ext:ro \
    -p 8988:8888 -p 6106:6006 -p 8197:8097 \
    -e "TERM=xterm-256color" \
    --shm-size=1g --ulimit memlock=-1 \
    -w /workspace \
    ${PROJECT_NAME}-tf

-w /workspace
--user $(id -u):$(id -g) \

### get services running in background
xvfb-run -s "-screen 0 1400x900x24" jupyter-notebook --ip=0.0.0.0 --allow-root
jupyter-notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root 2>&1 &
nohup python -m visdom.server 2>&1 &


## test DeepMimic
nvidia-docker run -ti \
    --name ${PROJECT_NAME} \
    -v ${HOME}/projects/${PROJECT_NAME}/code:/workspace/code \
    -v ${HOME}/projects/extern:/workspace/code-ext \
    -v ${HOME}/data/${PROJECT_NAME}:/workspace/data:ro \
    -v ${HOME}/data/${PROJECT_NAME}/output:/workspace/output \
    -v ${HOME}/data:/workspace/data-ext:ro \
    -p 8988:8888 -p 6106:6006 -p 8197:8097 \
    -e "TERM=xterm-256color" \
    --shm-size=1g --ulimit memlock=-1 \
    -w /workspace \
    tensorflow-1.12:latest /bin/bash

## training
```
python mpi_run.py --arg_file args/train_humanoid3d_run_args.txt --num_workers 18
```

## call different scripts
./scripts/build_cmake.sh


docker run -ti --rm -p 6080:80 -p 5900:5900 dorowu/ubuntu-desktop-lxde-vnc:bionic bash
