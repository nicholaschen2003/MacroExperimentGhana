import csv
import re
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup 
import time
import requests
import pandas as pd

options = webdriver.ChromeOptions()
options.add_experimental_option('excludeSwitches', ['enable-logging'])
service = ChromeService(executable_path=ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=options)
url = "https://www.bog.gov.gh/economic-data/time-series/" 
driver.get(url)

# select data
variables_dropdown = driver.find_element(By.XPATH, "//button[@title='Variables']")
driver.execute_script("arguments[0].click();", variables_dropdown)
real_growth = driver.find_element(By.XPATH, "//span[text()='Bank of Ghana Composite Index of Economic Activity (Real Growth)  (%)']")
driver.execute_script("arguments[0].click();", real_growth)
core_inflation = driver.find_element(By.XPATH, "//span[text()='Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year']")
driver.execute_script("arguments[0].click();", core_inflation)
monetary_policy_rate = driver.find_element(By.XPATH, "//span[text()='Monetary Policy Rate (%)']")
driver.execute_script("arguments[0].click();", monetary_policy_rate)
headline_inflation = driver.find_element(By.XPATH, "//span[text()='Headline Inflation (%) Year-on-Year']")
driver.execute_script("arguments[0].click();", headline_inflation)

# expand table
expand_table = driver.find_element(By.XPATH, "//span[@class='filter-option pull-left' and text()='5']")
driver.execute_script("arguments[0].click();", expand_table)
all_view = driver.find_element(By.XPATH, "//span[@class='text' and text()='All']")
driver.execute_script("arguments[0].click();", all_view)

time.sleep(20) # wait for page to load

# get data
soup = BeautifulSoup(driver.page_source,"html.parser")
table = soup.find("table", id="table_2")
body = table.find("tbody")
d = {"Date" : [],
     "Bank of Ghana Composite Index of Economic Activity (Real Growth)  (%)" : [],
     "Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year" : [],
     "Monetary Policy Rate (%)" : [],
     "Headline Inflation (%) Year-on-Year" : []}
for row in body.find_all("tr"):
    cells = row.find_all("td")
    for i in range(len(cells)-1, 1, -1):
        date = f"{i-1}/1/{cells[0].get_text()}"
        if date not in d["Date"]:
            d["Date"].append(date)
        d[cells[1].get_text()].append(cells[i].get_text())

# replace missing values with none
for i in range(len(d["Date"])):
    if len(d["Bank of Ghana Composite Index of Economic Activity (Real Growth)  (%)"]) < i+1:
        d["Bank of Ghana Composite Index of Economic Activity (Real Growth)  (%)"].append(None)
    if len(d["Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year"]) < i+1:
        d["Core Inflation (Adjusted for Energy & Utility) (%) Year-on-Year"].append(None)
    if len(d["Headline Inflation (%) Year-on-Year"]) < i+1:
        d["Headline Inflation (%) Year-on-Year"].append(None)
    if len(d["Monetary Policy Rate (%)"]) < i+1:
        d["Monetary Policy Rate (%)"].append(None)

df = pd.DataFrame.from_dict(d)

df.to_csv("data.csv", index=False)