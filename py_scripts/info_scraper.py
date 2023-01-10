from bs4 import BeautifulSoup
from datetime import date
from prettytable import PrettyTable
import requests


date = date.today()
url = f"https://www.ote-cr.cz/en/short-term-markets/electricity/day-ahead-market?date={date}"


def request_url():

    headers = {
        "Accept": "*/*",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0) Gecko/20100101 Firefox/102.0"
    }
    # print(url)
    return requests.get(url, headers=headers)


def parse():
    soup = BeautifulSoup(request_url().text, 'lxml')
    data = soup.find(
        "div", class_="bigtable left-sticky").find("tbody").find_all("tr")
    row_data = []
    for i in data:
        change = f"{i.find_all('span')[0].text}{i.find_all('img')[0]['alt']}"
        total_volume = f"{i.find_all('span')[1].text}{i.find_all('img')[1]['alt']}"
        # print(f"{i.find('th').text}: {i.find('td').text} {change}")
        #
        row_data.append([i.find('th').text, i.find(
            'td').text, change])  # ,total_volume
    return row_data
# , "Total volume CZ (MWh)"


def main():
    row_data = parse()
    # return tabulate(row_data,headers='keys',tablefmt='fancy_grid',)
    x = PrettyTable()  # , "Total volume CZ (MWh)"
    x.field_names = ["Index", "EUR/MWh", "Change(%)"]
    x.add_rows(
        [
            row_data[0],
            row_data[1],
            row_data[2],
        ]
    )

    return x


if __name__ == '__main__':
    main()
