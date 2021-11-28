source utils.sh

function usage() {
    scriptname="$0"
    cat << EOF
Usage: $scriptname
Cleans home Downloads directory using default associations and destination directories.

Miscellaneous:
    -h, --help              print this help text and exit
    -q, --quiet             suppress printing messages to stdout

Associations and clean directory control:
    -b, --base DIR                      Base directory to use for finding sub path for cleaning. For example DIR=/home/user
                                        Will result in program cleaning /home/user/Downloads.
    -a, --associations ASSOCIATIONS     Semicolon separated rules.
                                        Example: 'pdf,txt=Documents;img=Pictures'

    -c, --config CONFIG                 run using configurations defined in CONFIG 

This tool provides functionallity for cleaning any directory by moving files to more dedicated directories.
Its main purpose is to clean home 'Downloads' directory.
EOF
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
            *) # unknown option
                print_error "Unknown option $1."
                usage
                shift
                ;;
        esac
    done
}

parse_args "$@"
# usage "clean.sh"