#!/bin/bash

function parse_args {
    help="
    "
}


# Associative array 
# mapping formats to destination folder
# eg ".pdf,".txt": "Documents" or "/home/bazyli/Documents"
source utils.sh

base_path="/home/bazyli/Programming/studia/PJS/smol_scripts/cleaner/test"
source_dir=Downloads

declare -A files_association
files_association=( ["pdf,txt"]="Documents" \
                    ["png,jpg"]="Pictures"
                    ["mp3,wav"]="Music"
                    ["foo"]="wrong"
)

print_info "Starting..."

# figure out source dir 
[ ! -d "$source_dir" ] && print_warning "Directory {./${source_dir}} do not exist." && \
                          source_dir="${base_path}/${source_dir}"
[ ! -d "$source_dir" ] && print_error "Directory {${source_dir}} do not exist!" &&
                          print_error "Cannot clean empty directory! Exiting..." && exit 1

print_info "Will clean $source_dir."

# loop moving files into correcd directories
for ext in ${!files_association[*]}
do
    echo
    echo ext: $ext val: ${files_association[$ext]}

    # figure out destination dir 
    destination_dir=${files_association[$ext]}
    [ ! -d "$destination_dir" ] && destination_dir="${base_path}/${destination_dir}"
    [ ! -d "$destination_dir" ] && print_warning "Directory {${destination_dir}} do not exist!" \
    && continue
    
    IFS=',' read -ra extensions <<< "$ext"
    for extension in "${extensions[@]}"
    do
        echo ext: $extension dest: $destination_dir
        for file in "$source_dir"/*
        do
            [[ $file =~ .$ext ]] && echo "found"
        done
    done

done
