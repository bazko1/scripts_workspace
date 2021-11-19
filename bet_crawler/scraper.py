from bs4 import BeautifulSoup
import requests


class Scraper:
    def __init__(self, base_url):
        self.base_url = base_url
        self.entries = []

    def get_entries(self):
        out = []
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
            out.append((discipline, self.base_url + url, ))

        self.entries = out
        return out


    def get_discipline_names(self):
        pass

    def get_discipline_urls(self):
        pass

    def get_bets(self, discipline):
        pass

# interface for getting main page
# getting disciplines
# getting actual bets and stakes for each discipline