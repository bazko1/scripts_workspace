LOG_FILE=cleaner.log
QUIET=false
DRY_RUN=true

# Recreate log file every run
:> $LOG_FILE

function print_error() {
    $QUIET && return
    echo -e "ERROR: $*" | tee -a $LOG_FILE >&2
}

function print_warning() {
    $QUIET && return
    echo -e "WARNING: $*" | tee -a $LOG_FILE >&2
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
    print_info "Would move {$1} to {$2}." && \
    return

    mv "$1" "$2"
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
    base_path="$1"
    source_dir="$2"
    files_association="$3"

    # loop moving files into correct directories
    for ext in ${!files_association[*]}
    do
        # figure out destination dir
        destination_dir=${files_association[$ext]}
        [ ! -d "$destination_dir" ] && destination_dir="${base_path}/${destination_dir}"
        [ ! -d "$destination_dir" ] && print_warning "Directory {${destination_dir}} do not exist!" \
        && continue

        IFS=',' read -ra extensions <<< "$ext"
        for extension in "${extensions[@]}"
        do
            for file in "$source_dir"/*
            do
                [[ $file =~ ^.*\.$extension$ ]] && \
                move_file $file $destination_dir
            done
        done

    done
}

