#/bin/bash

srce_name=${1:-"trans-imit"}
extn_dir="$HOME/projects/extern"
build_dir="$HOME/projects/build"
srce_dir="$HOME/projects/$srce_name"

printf "\n\n"
read -p "regenerate source? y/[n] >" -n 1 -r
printf "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
fi

cmake \
    -DEXTERN_DIR=${extn_dir} \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -B${build_dir} \
    -H${srce_dir}
