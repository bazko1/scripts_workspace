#!/bin/bash

source utils.sh
source argparser.sh

parse_args "$@"

[ -z "${base_path}" ] && base_path="$HOME"
[ -z "${source_dir}" ] && source_dir="Downloads"

declare -A files_association
[ -z "${associations}" ] && \
files_association=( ["pdf,txt"]="Documents"
                    ["png,jpg"]="Pictures"
                    ["mp3,wav"]="Music"
                    ["mp4,mkv"]="Videos"
) || parse_associations "${associations}"

# figure out source dir
[ ! -d "$source_dir" ] && print_warning "Directory {./${source_dir}} do not exist. Will try absolute path." && \
                          source_dir="${base_path}/${source_dir}"
[ ! -d "$source_dir" ] && print_error "Directory {${source_dir}} do not exist!" &&
                          print_error "Cannot clean empty directory! Exiting..." && exit 1

print_info "Will clean $source_dir."
clean_directory "$base_path" "$source_dir" "$files_association"
exit 0