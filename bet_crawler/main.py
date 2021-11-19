#!/usr/bin/env python3
from bs4 import BeautifulSoup
import requests
import re
import sts
import scraper
import sys
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description="""
    Program scrapes data about bets from the sts.pl betting site. \n

    """,
    epilog="""Examples:
     """)
    sub = parser.add_subparsers(dest="command")
    info_parser = sub.add_parser("info", help="Program displays information about events.")
    info_parser.add_argument("-d", "--disciplines", required=False, help="Comma separated list of disciplines to display information about.")
    sub.add_parser("list", help="Program only lists disciplines available on main paige and exits.")

    return parser.parse_args()

if __name__ == "__main__":
    BASE_URL = "https://sts.pl"
    s = scraper.Scraper(BASE_URL)
    args = parse_args()
    if args.command == "list":
        print("\n".join(s.get_discipline_names()))
    elif args.command == "list":
        pass
    # for discipline, discipline_url in s.get_entries().items():

    #     if discipline == "koszykowka":
    #         ev = s.get_discipline_events(discipline)
    #         for e in ev:
    #             print(str(e) + "\n")
