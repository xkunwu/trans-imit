#!/bin/bash

#base_dir=${1:-.}
base_dir=${1:-./DeepMimicCore}
search_pat=${2:-"*.cpp"}
print_header=${3:-'set (CURR_SRCS_LIST\n'}

source_dirs="util/ \
	util/json/ \
	anim/ \
	sim/ \
	render/ \
	render/lodepng/ \
	scenes/ \
	scenes/arm/ \
	scenes/particle/ \
	scenes/pendulum/"

printf "$print_header"
for dir in $source_dirs; do
    cudir=$base_dir/$dir
    if [ -d $cudir ]; then
        find $cudir -maxdepth 1 -type f -name $search_pat -printf "    $base_dir/$dir%f\n"
    fi
done
printf ")\n"

printf "\n"

printf "set (CURR_INCS_LIST\n"
find $base_dir -type f -name '*.h' -printf '    %h\n' | sort -u
printf ")\n"
