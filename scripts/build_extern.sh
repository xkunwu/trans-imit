#/bin/bash

set -e

# git clone https://github.com/eigenteam/eigen-git-mirror.git
# git clone https://github.com/bulletphysics/bullet3.git

srce_name=${1:-"trans-imit"}
#srce_dir=${1:-"$HOME/projects/$srce_name"}
extn_dir="$HOME/projects/extern"
build_dir="$HOME/projects/build"
build_srce="$build_dir/$srce_name"
targ_name="bullet3"
targ_dir="${extn_dir}/${targ_name}"
build_targ="$build_dir/$targ_name"

cd ${targ_dir}

## apply patch
# patch_name=${targ_name}.patch
# if [ ! -f ${targ_dir}/${patch_name} ] && [ -f ${srce_dir}/extern/${patch_name} ]; then
#     echo "patching from ${srce_dir}/extern/${patch_name} to ${targ_dir}/${patch_name} ..."
#     cp ${srce_dir}/extern/${patch_name} ${targ_dir}/${patch_name}
#     git apply ${patch_name}
# fi

mkdir -p ${build_srce}
mkdir -p ${build_targ}
cmake \
    -DBUILD_PYBULLET=ON -DBUILD_PYBULLET_NUMPY=ON \
    -DUSE_DOUBLE_PRECISION=OFF -DBT_USE_EGL=ON \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_INSTALL_PREFIX=${build_dir} \
    -B${build_targ} \
    -H${targ_dir}
cd ${build_targ}
make -j $(command nproc 2>/dev/null || echo 12) || exit 1
make install
