#!/usr/bin/env python3


#  from bs4 import BeautifulSoup TODO: Add check if library exists
import sys
import argparse
import importlib.util

def parse_args():
    parser = argparse.ArgumentParser(
        description="Program scrapes data about bets from the sts.pl betting site.",
        epilog=f"""Examples:
    %(prog)s list
    > esport, futbol-amerykanski, futsal, golf

    %(prog)s info -d 'szachy' -p
    > szachy - Mistrzostwa Świata, Rozgr. międzynarodowe
    > 16.12.2021 - 12:00
    > Carlsen M. - X - Nepomniachtchi I.
    > 1.45 - 5.00 - 5.00

    %(prog)s info -d 'koszykowka'
    """,
        formatter_class=argparse.RawTextHelpFormatter)

    sub = parser.add_subparsers(dest="command")
    info_parser = sub.add_parser("info", help="Program prints information about events. Call `%(prog)s info -h` for information about parameters.")
    info_parser.add_argument("-d", "--disciplines", required=False, help="Comma separated list of disciplines to display information about.")
    info_parser.add_argument("-p", "--print", required=False, help="Print matches information to standard out instead of to file.", action="store_true")
    info_parser.add_argument("-o", "--outfile", required=False, help="Output file. By default its ./bets.txt", default="bets.txt")

    sub.add_parser("list", help="Program only lists disciplines available on main paige and exits.")

    return parser.parse_args()

def check_dependecies():
    if sys.version_info < (3, 6, 0):
        print("ERROR: This tool needs python 3.6+, please install never python.\n")
        return False

    package_list = ["bs4", "requests"]
    for name in package_list:
        if not importlib.util.find_spec(name):
            print(f"ERROR: Program requires package '{name}' to be installed.\n"
                  "Please install pip and then package by running:\n"
                  f"> python3 -m pip install {name}\n")
            return False
    return True

if __name__ == "__main__":
    args = parse_args()
    deps_ok = check_dependecies()
    if not deps_ok:
        print("Dependecies not satisfied.")
        sys.exit(1)

    import scraper
    BASE_URL = "https://sts.pl"
    s = scraper.Scraper(BASE_URL)
    if args.command == "list":
        print(", ".join(s.get_discipline_names()))
    elif args.command == "info":
        disciplines = args.disciplines.replace(" ", "").split(",")
        if args.print:
            f = sys.stdout
        else:
            f = open(args.outfile, "w")

        for discipline in disciplines:
            ev = s.get_discipline_events(discipline)
            for e in ev:
                print(str(e), file=f)
        f.close()
    else:
        print("ERORR: Please provide subcommand {list, info}.")
        sys.exit(1)
    sys.exit(0)

