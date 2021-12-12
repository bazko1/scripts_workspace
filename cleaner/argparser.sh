function usage() {
    scriptname=$(basename "$0")
    cat << EOF
Usage: $scriptname [OPTIONS]
Cleans home Downloads directory using default associations and destination directories.

Miscellaneous:
    -h, --help                Print this help text and exit

    -q, --quiet               Suppress printing messages

    -d, --dry-run             Do not move any file just print what would happen

Associations and clean directory control:
    -b, --base-dir DIR                  Base directory to use for finding sub path for cleaning. For example DIR=/home/user
                                        Will result in program cleaning /home/user/SOURCE_DIR.
                                        Default: \$HOME=${HOME}
    
    -s, --source-dir DIR                Directory to be cleaned if not defined default will be taken.
                                        Default: Downloads.

    -a, --associations ASSOCIATIONS     Semicolon separated rules. If not given default will be used.
                                        Example: 'pdf,txt=Documents;img=Pictures'.
                                        Default: ${DEFAULT_ASSOCIATIONS}

    -r, --recursive                     Parse source directory recursively for subfolders.
                                        Example: In default config will clean also Downloads/subfolder and its
                                        subfolders if such exists.

    --max-depth DEPTH                   Defines max recurse depth level, takes effect only if given with -r 
                                        flag. Example DEPTH=1 will clean Download, Download/sub1 and Download/sub2 
                                        but will not clean Download/sub1/sub3.

This tool provides functionallity for cleaning any directory by moving files to more dedicated directories.
Its main purpose is to clean home 'Downloads' directory.
Note: Defining associations nd paths override their defaults values.

Examples:
    # Perform recursive cleaning dry run on test directory using default associations and limit depth.
    $scriptname -d -b ./test/ -r --max-depth 1
    
    # Perform recursive cleaning dry run with custom associations.
    $scriptname -d -b ./test/ -r -a 'pdf=Documents;mp3,wav=Music'
    
    # Dry run for local user cleaning
    $scriptname -d
EOF
    exit 0
}

function parse_args() {
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            -h|--help)
                usage;
                shift
                ;;
            -q|--quiet)
                QUIET=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -b|--base-dir)
                base_path="$2"
                shift
                shift
                ;;
            -s|--source-dir)
                source_dir="$2"
                shift
                shift
                ;;
            -a|--associations)
                associations="$2"
                shift
                shift
                ;;
            -r|--recursive)
                RECURSIVE=true
                shift
                ;;
            --max-depth)
                MAX_DEPTH="$2"
                shift
                shift
                ;;
            *) # unknown option
                print_error "Unknown option '$1'."
                usage
                shift
                ;;
        esac
    done
}