FROM exp:cuda

USER root

RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        libopenmpi-dev python3-dev \
        swig libglew-dev freeglut3-dev

# vnc jupyter tensorboard
EXPOSE $VNC_PORT 8888 6006

WORKDIR /workspace

ARG USER_ME=me
ARG USER_UID=1000
ARG USER_GID=1000

USER $USER_UID

# ENTRYPOINT ["/startup.sh"]
CMD ["/startup.sh"]
