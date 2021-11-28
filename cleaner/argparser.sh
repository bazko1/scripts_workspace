source utils.sh

function usage() {
    scriptname="$0"
    cat << EOF
Usage: $scriptname
Cleans home Downloads directory using default associations and destination directories.

Miscellaneous:
    -h, --help                Print this help text and exit
    -q, --quiet               Suppress printing messages
    -d, --dry-run             Do not move any file just print what would happen

Associations and clean directory control:
    -b, --base-dir DIR                  Base directory to use for finding sub path for cleaning. For example DIR=/home/user
                                        Will result in program cleaning /home/user/Downloads.
    -s, --source-dir DIR                Directory to be cleaned if not defined default will be taken  - Downloads.

    -a, --associations ASSOCIATIONS     Semicolon separated rules. If not given default will be used.
                                        Example: 'pdf,txt=Documents;img=Pictures'

    -c, --config CONFIG                 run using configurations defined in CONFIG 

This tool provides functionallity for cleaning any directory by moving files to more dedicated directories.
Its main purpose is to clean home 'Downloads' directory.
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
            -c|--config)
                config_file="$2"
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