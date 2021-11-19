from bs4 import BeautifulSoup
import requests
import re
import sts
import scraper
import sys

BASE_URL = "https://sts.pl"
s = scraper.Scraper(BASE_URL)
print(s.get_entries())
sys.exit(0)


request = requests.get(BASE_URL)
request.raise_for_status()

soup = BeautifulSoup(request.text, "html.parser")

sports_table = soup.find(id="bets").find("ul")

sport_entries = sports_table.find_all("li")

for entry in sport_entries:
    a = entry.find("a", href=True)
    url = a["href"]
    url_parts = url.split("/")

    # ignore some empty entries
    if len(url_parts) < 2:
        continue

    # TODO: The second argument is somekind of number. Is it usefull ?
    discipline, _ = url_parts[-3], url_parts[-2]

    # ignore special as they should be in specific discipline # TODO: Ensure When able to scrape matches
    if discipline == "zaklady-specjalne":
        continue

    if discipline == "koszykowka":
        discipline_url = BASE_URL + url
        print(discipline_url)
        request = requests.get(discipline_url)
        request.raise_for_status()
        discipline_soup = BeautifulSoup(request.text, "html.parser")

        matches = discipline_soup.find_all(
            "table", {"class": re.compile(r"^col\d+$")})

        
        match = matches[0]
        bet = sts.Bet.from_col(match, discipline=discipline)
        print(bet)
