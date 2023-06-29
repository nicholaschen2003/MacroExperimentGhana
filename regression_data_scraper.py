import csv
import re
from bs4 import BeautifulSoup 
import time
import requests
import pandas as pd

with open("World Development Indicators _ DataBank.html") as f:
    soup = BeautifulSoup(f, 'html.parser')
table = soup.find("table", id="grdTableView_DXMainTable")
body = table.find("tbody")
d = {"Year" : [],
     "GDP growth (annual %)" : [],
     "GDP per person employed (constant 2017 PPP $)" : [],
     "Broad money (% of GDP)" : [],
     "Labor force, total" : [],
     "Consumer price index (2010 = 100)": []}
years = soup.find("tr", id="grdTableView_DXHeadersRow0")
for element in years.find_all("td")[-1:0:-2]:
    print(element)
    if element.find("span", class_="grid-column-text") is not None:
        year = element.find("span", class_="grid-column-text").get_text()
        d["Year"].append(year)
for row in body.find_all("tr")[1:]:
    cells = row.find_all("td")
    for i in range(len(cells)-1, 0, -1):
        if cells[i].get_text() == "..":
            d[cells[0].get_text()].append(None)
        elif cells[i].get_text() != "":
            d[cells[0].get_text()].append(float(cells[i].get_text()))

for key in d.keys():
    print(len(d[key]))

df = pd.DataFrame.from_dict(d)

df.to_csv("regression_data.csv", index=False)