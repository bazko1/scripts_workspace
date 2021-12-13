#!/bin/bash
script_path=$(dirname $0)
source ${script_path}/utils.sh
source ${script_path}/argparser.sh

parse_args "$@"

[ -z "${base_path}" ] && base_path="$HOME"
[ -z "${source_dir}" ] && source_dir="${DEFAULT_SOURCE}"

declare -A files_association
[ -z "${associations}" ] && associations="${DEFAULT_ASSOCIATIONS}"
parse_associations "${associations}"

# figure out source dir
[ ! -d "$source_dir" ] && print_warning "Directory {./${source_dir}} do not exist. Will join with base path." && \
                          source_dir="${base_path}/${source_dir}"
[ ! -d "$source_dir" ] && print_error "Directory {${source_dir}} do not exist!" &&
                          print_error "Cannot clean empty directory! Exiting..." && exit 1

print_info "Will clean {$source_dir} ."
clean_directory "${base_path}" "${source_dir}"
exit 0