LOG_FILE=cleaner.log
QUIET=false
DRY_RUN=true

# Recreate log file every run
$QUIET && :> $LOG_FILE

function print_error {
    $QUIET && return
    echo -e "ERROR: $*" | tee -a $LOG_FILE >&2
}

function print_warning {
    $QUIET && return
    echo -e "WARNING: $*" | tee -a $LOG_FILE >&2
}

function print_info {
    $QUIET && return
    echo -e "INFO: $*" | tee -a $LOG_FILE
}

function move_file {
    $DRY_RUN && \
    print_info "Would move {$1} to {$2}." && \
    return

    mv "$1" "$2"
}


function clean_directory {
    base_path="$1"
    source_dir="$2"
    files_association="$3"
}

