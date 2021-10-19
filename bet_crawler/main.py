from bs4 import BeautifulSoup
import requests
import re

BASE_URL = "https://sts.pl"

request = requests.get(BASE_URL)
request.raise_for_status()

soup = BeautifulSoup(request.text, "html.parser")

sports_table = soup.find(id="bets").find("ul")
# print(sports_table)

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
        event = match.find("span", {"class": "liga"})
        match_name = match.find("td", {"class": "matchName"})
        start_time = match.find("td", {"class": "date_time"})
        start_day = match.find("span", {"class": "date"})
        bet = match.find_all("td", {"class": "bet"})
        
        print('event:', re.sub("\s", "", ''.join(event.stripped_strings)))
        print('day:', re.sub("[a-zA-Z]|-|\s", "", ''.join(start_day.stripped_strings)))
        print('time:', ''.join(start_time.stripped_strings))
        if match_name:
            print('name:', ''.join(match_name.stripped_strings))

        bet_stake = list(map(lambda x: tuple(x.stripped_strings), bet))
        print(bet_stake)

    # print(discipline, number)

    # print("=" * 10)
