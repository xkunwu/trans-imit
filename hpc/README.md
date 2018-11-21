## interactive
ssh xw943@balena
sinteractive --constraint=p100

## submit job
sbatch $HOME/projects/trans-imit/hpc/jobscript.slm
squeue | grep xw943
scontrol show job 123456

## check disk usage
du -smhc * .[a-zA-Z0-9]*

## load module
module avail
module load python/3.6
module load cuda/toolkit/9.0.176
module load cudnn/cuda90/7.1.4
module list

## install packages
pip3 install --user \
    torch \
    torchvision \
    visdom \
    dominate \
    opencv-python \
    matplotlib \
    scikit-image \
    pycocotools

## patch python
module load patchelf/0.8
patchelf --print-interpreter ~/bin/python
patchelf --print-rpath ~/bin/python
patchelf --set-interpreter /apps/gnu/glibc/2.23/lib/ld-linux-x86-64.so.2 ~/bin/python
patchelf --print-interpreter ~/bin/python
patchelf --force-rpath --set-rpath \$ORIGIN/../lib:/apps/gnu/glibc/2.23/lib ~/bin/python
patchelf --print-rpath ~/bin/python
python
