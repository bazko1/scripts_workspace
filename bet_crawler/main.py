#!/usr/bin/env python3
from bs4 import BeautifulSoup
import requests
import re
import sys
import argparse

import sts
import scraper

def parse_args():
    parser = argparse.ArgumentParser(
        description="Program scrapes data about bets from the sts.pl betting site.",
        epilog=f"""Examples:
    {sys.argv[0]} list
    > esport, futbol-amerykanski, futsal, golf
            
    {sys.argv[0]} info -d 'szachy' -p
    > szachy - Mistrzostwa Świata, Rozgr. międzynarodowe
    > 16.12.2021 - 12:00
    > Carlsen M. - X - Nepomniachtchi I.
    > 1.45 - 5.00 - 5.00
    
    {sys.argv[0]} info -d 'koszykowka'
    """,
        formatter_class=argparse.RawTextHelpFormatter)

    sub = parser.add_subparsers(dest="command")
    info_parser = sub.add_parser("info", help="Program prints information about events.")
    info_parser.add_argument("-d", "--disciplines", required=False, help="Comma separated list of disciplines to display information about.")
    info_parser.add_argument("-p", "--print", required=False, help="Print matches information to standard out instead of to file.", action="store_true")
    info_parser.add_argument("-o", "--outfile", required=False, help="Output file. By default its ./bets.txt", default="bets.txt")
    
    sub.add_parser("list", help="Program only lists disciplines available on main paige and exits.")

    return parser.parse_args()

if __name__ == "__main__":
    BASE_URL = "https://sts.pl"
    s = scraper.Scraper(BASE_URL)
    args = parse_args()
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

