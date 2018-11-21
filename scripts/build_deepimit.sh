#!/bin/bash

srce_name=${1:-"trans-imit"}
targ_name="deepimit"
extn_dir="$HOME/projects/extern"
build_dir="$HOME/projects/build"
srce_dir="$HOME/projects/$srce_name"
targ_dir=${2:-"${HOME}/projects/extern/DeepMimic/DeepMimicCore"}
#build_type=${3:-"Debug"}
build_type=${3:-"RelWithDebInfo"}
build_targ="$build_dir/$targ_name/$build_type"
targ_listing="$targ_dir/srce_list.cmake.in"

printf "\n"
read -p "regenerate source list? y/[n] >" -n 1 -r
printf "\n"

cmp --silent ${targ_dir}/CMakeLists.txt ${srce_dir}/CMakeLists.txt || { 
    echo "copy: ${srce_dir}/CMakeLists.txt --> ${targ_dir}/CMakeLists.txt";
    cp ${srce_dir}/CMakeLists.txt ${targ_dir}/CMakeLists.txt;
}
#exit 0

if [[ $REPLY =~ ^[Yy]$ ]] || [ ! -f $targ_listing ]; then
	./scripts/collect_srcs.sh $targ_dir "*.cpp" 'set (CURR_SRCS_LIST\n' > $targ_listing
    printf "source list regenerated: $targ_listing\n"
fi

#swig -c++ -python -outdir $targ_dir -o DeepMimicCore_wrap.cxx $targ_dir/DeepMimicCore.i

mkdir -p ${build_targ}
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++
cmake \
    -DEXTERN_DIR=${extn_dir} \
	-DBUILD_DIR="$build_dir" \
	-DEXTRA_MODULE="$srce_dir/cmake" \
    -DCMAKE_BUILD_TYPE=$build_type \
    -DCMAKE_INSTALL_PREFIX=${build_dir} \
    -B${build_targ} \
    -H${targ_dir}
cd ${build_targ}
make -j $(command nproc 2>/dev/null || echo 12) || exit 1
#make -j1 || exit 1
make install
