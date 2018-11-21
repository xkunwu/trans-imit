#!/bin/bash

set -e

cd $HOME/projects/extern
pip install mpi4py
pip install ./tensorflow-1.12.0rc0-cp36-cp36m-linux_x86_64.whl
pip install gym pybullet

#pushd .
#cd gym
#git pull
#pip install -e .
#popd
#
#pushd .
#cd bullet3
#git pull
#pip install -e .
#popd
#
