#!/bin/bash

source utils.sh

base_path="./test"
source_dir="test/Downloads"

declare -A files_association
files_association=( ["pdf,txt"]="Documents"
                    ["png,jpg"]="Pictures"
                    ["mp3,wav"]="Music"
                    ["mp4,mkv"]="Videos"
)

# figure out source dir
[ ! -d "$source_dir" ] && print_warning "Directory {./${source_dir}} do not exist. Will try absolute path." && \
                          source_dir="${base_path}/${source_dir}"
[ ! -d "$source_dir" ] && print_error "Directory {${source_dir}} do not exist!" &&
                          print_error "Cannot clean empty directory! Exiting..." && exit 1

print_info "Will clean $source_dir."
clean_directory "$base_path" "$source_dir" "$files_association"

