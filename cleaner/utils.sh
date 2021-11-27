LOG_FILE=cleaner.log
QUIET=false
DRY_RUN=true

# Recreate log file every run
:> $LOG_FILE

function print_error {
    echo -e "ERROR: $*" | tee -a $LOG_FILE >&2
}

function print_warning {
    echo -e "WARNING: $*" | tee -a $LOG_FILE >&2
}

function print_info {
    echo -e "INFO: $*" | tee -a $LOG_FILE
}

function move_file {
    mv "$1" "$2"
}


function clean_directory {
    base_path="$1"
    to_clean="$2"
    files_association="$3"
}

