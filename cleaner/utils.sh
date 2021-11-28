LOG_FILE=cleaner.log
QUIET=false
DRY_RUN=false
RECURSIVE=false
# Recreate log file every run
$QUIET && :> $LOG_FILE

function print_error() {
    $QUIET && return
    echo -e "ERROR: $*" | tee -a $LOG_FILE >&2
}

function print_warning() {
    $QUIET && return
    echo -e "WARNING: $*" | tee -a $LOG_FILE
}

function print_info() {
    $QUIET && return
    echo -e "INFO: $*" | tee -a $LOG_FILE
}

#######################################
# Moves file to different location as 'mv' functionality
# or logs information about operation in case of dry run.
#######################################
function move_file() {
    $DRY_RUN && \
    print_info "Would move {${1}} to {${2}}." && \
    return

    mv "${1}" "${2}"
}

#######################################
# Cleans given source directory by moving files
# to directories defined by extensions.
# Arguments:
#   Base path for constructing full paths
#   Directory to clean
#   Dictionary with associations extension -> Directory
#######################################
function clean_directory() {
    base_path="${1}"
    source_dir="${2}"
    files_association="${3}"

    recurse_dirs=( "${source_dir}" )

    function main_loop() {
        loop_over="${1}"
        recurse_dirs=()

        for file in "${loop_over}"/*
        do
            if [ -d "${file}" ] && $RECURSIVE
            then
                recurse_dirs+=("${file}")
                continue

            fi

            # loop moving files into correct directories
            for ext in ${!files_association[*]}
            do
                # figure out destination dir
                destination_dir="${files_association[$ext]}"
                [ ! -d "$destination_dir" ] && destination_dir="${base_path}/${destination_dir}"
                [ ! -d "$destination_dir" ] && print_warning "Directory {${destination_dir}} do not exist!" \
                && continue

                IFS=',' read -ra extensions <<< "$ext"

                for extension in "${extensions[@]}"
                do
                    [[ $file =~ ^.*\.$extension$ ]] && \
                    move_file "${file}" "${destination_dir}"
                done
            done
        done
    }

    depth_counter=0
    while [ "${#recurse_dirs[@]}" -gt 0 ]
    do
        $RECURSIVE && [ -n "${MAX_DEPTH}" ] \
        && [ $depth_counter -gt $MAX_DEPTH ] && break

        for rec_dir in "${recurse_dirs[@]}"
        do
            main_loop "$rec_dir"
        done
        ((depth_counter++))
    done

}

#######################################
# Parse given string as if it was
# associations config.
# Input example 'pdf,txt=Documents;img=Pictures'
#######################################
function parse_associations() {
    input=$1
    echo INP $input
    IFS=';' read -ra rules <<< "$input"
    for rule in "${rules[@]}"
    do
        echo RULE $rule
        IFS='=' read ext dir <<< "$rule"
        files_association["$ext"]="$dir"
    done
}