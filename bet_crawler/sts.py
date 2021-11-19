import re
import datetime


class Bet:
    "Representing single bet"
    
    def __init__(self, discipline=None, event=None, match_name=None, date=(None, None), bet=None) -> None:
        self.discipline = discipline
        self.event = event
        self.match_name = match_name
        self.date = date
        self.bet = bet
        
    def __repr__(self):
        return f"{self.discipline} - {self.event} | {' - '  + self.match_name if self.match_name else ''}\n" \
               f"{self.date}\n" \
               f"{' - '.join(self.bet.keys())}\n" \
               f"{' - '.join(self.bet.values())}"
    
    def get_shared_items(self):
        return (self.event, *self.date,)
    
    @staticmethod
    def from_col(match_col, discipline=None, prev_event=None, prev_day=None, prev_time=None):
        event = match_col.find("span", {"class": "liga"})
        match_name = match_col.find("td", {"class": "matchName"})
        start_time = match_col.find("td", {"class": "date_time"})
        start_day = match_col.find("span", {"class": "date"})
        bet = match_col.find_all("td", {"class": "bet"})
        
        event = re.sub("\n", "", ''.join(event.stripped_strings)) if event else prev_event
        day = re.sub("[^0-9\.]", "", ''.join(start_day.stripped_strings)) if start_day else prev_day
        time = ''.join(start_time.stripped_strings) if start_time else prev_time
        match_name = ''.join(match_name.stripped_strings) if match_name else None
        
        date = (day, time)
        bet_stake = dict(map(lambda x: tuple(x.stripped_strings), bet))
        return Bet(discipline, event, match_name, date, bet_stake)