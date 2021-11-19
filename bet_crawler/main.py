from bs4 import BeautifulSoup
import requests
import re
import sts
import scraper
import sys

BASE_URL = "https://sts.pl"
s = scraper.Scraper(BASE_URL)
# print(s.get_entries())
# print(s.get_discipline_names())
# print(s.get_discipline_urls())
# sys.exit(0)


for discipline, discipline_url in s.get_entries().items():

    if discipline == "koszykowka":
        s.get_discipline_events(discipline)
        # print(discipline_url)
        # request = requests.get(discipline_url)
        # request.raise_for_status()
        # discipline_soup = BeautifulSoup(request.text, "html.parser")

        # matches = discipline_soup.find_all(
        #     "table", {"class": re.compile(r"^col\d+$")})

        
        # match = matches[0]
        # bet = sts.Bet.from_col(match, discipline=discipline)
        # print(bet)
