from bs4 import BeautifulSoup
import requests
import sys
import re
import sts


class Scraper:
    def __init__(self, base_url):
        self.base_url = base_url
        self.entries = {}

    def get_entries(self):
        request = requests.get(self.base_url)
        request.raise_for_status()
        soup = BeautifulSoup(request.text, "html.parser")
        sports_table = soup.find(id="bets").find("ul")
        sport_entries = sports_table.find_all("li")
        for entry in sport_entries:
            a = entry.find("a", href=True)
            url = a["href"]
            url_parts = url.split("/")

            if len(url_parts) < 2:
                # TODO: This could add some log about failure
                continue

            discipline = url_parts[-3]
            self.entries[discipline] = self.base_url + url

        return self.entries


    def get_discipline_names(self):
        if not self.entries:
            self.get_entries()
        return list(self.entries.keys())

    def get_discipline_urls(self):
        if not self.entries:
            self.get_entries()
        return list(self.entries.values())

    def get_discipline_events(self, discipline):
        if not self.entries:
            self.get_entries()
        if not discipline in self.entries:
            print(f"Discipline '{discipline}' does not exist", file=sys.stderr)
            return []
        
        discipline_url = self.entries[discipline]

        request = requests.get(discipline_url)
        request.raise_for_status()
        discipline_soup = BeautifulSoup(request.text, "html.parser")

        matches = discipline_soup.find_all(
            "table", {"class": re.compile(r"^col\d+$")})
        output = []
        for id_, match in enumerate(matches):
            prev = sts.Bet()
            if id_ > 0:
                prev = output[id_ - 1]
            output.append(sts.Bet.from_col(match, discipline, *prev.get_shared_items()))

        return output
