#!/bin/bash

export PATH="$HOME/bin:$PATH"
$HOME/bin/python $HOME/projects/trans-imit/code/cgan-pix/train.py \
    --epoch_count=1 \
    --display_id -1 \
    --dataroot=$SCRATCH/exchange/data \
    --outroot=$SCRATCH/exchange/output \
    --data=horse2zebra \
    --model=cycle_gan
