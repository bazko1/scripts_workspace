class Bet:
    "Representing single bet"
    
    def __init__(self, discipline=None, event=None, match_name=None, date=None, bet=None) -> None:
        self.discipline = discipline
        self.event = event
        self.match_name = match_name
        self.date = date
        self.bet = bet
        self.players = []
        
    def __repr__(self):
        pass
    
    @staticmethod
    def from_col(match_col, discipline=None):
        event = match_col.find("span", {"class": "liga"})
        match_name = match_col.find("td", {"class": "matchName"})
        start_time = match_col.find("td", {"class": "date_time"})
        start_day = match_col.find("span", {"class": "date"})
        bet = match_col.find_all("td", {"class": "bet"})

        event = re.sub("\s", "", ''.join(event.stripped_strings))
        day = re.sub("[a-zA-Z]|-|\s", "", ''.join(start_day.stripped_strings))
        time = ''.join(start_time.stripped_strings)
        
        if match_name:
            match_name = ''.join(match_name.stripped_strings)

        bet_stake = list(map(lambda x: tuple(x.stripped_strings), bet))
        return Bet(discpline, event, match_name, date, bet_stake)