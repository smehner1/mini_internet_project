#!/usr/bin/python3

import csv
import pandas as pd
import matplotlib.pyplot as plt

csv_file="./stats/user_activity.csv"

# get group names form AS_config -> all groups with NoConfig

group_names=["date"]

with open('config/AS_config.txt', mode ='r')as file:
   
  # reading the CSV file
  csvFile = csv.reader(file, delimiter='\t')
 
  # displaying the contents of the CSV file
  for lines in csvFile:
    ASN=lines[0]
    config=lines[2]
        
    if config == "NoConfig":
        group_names.append(ASN)

print(group_names)
df = pd.read_csv(csv_file, header=None, sep=" ", names=group_names)
df['date']=pd.to_datetime(df['date'])


df.plot.line(y=group_names[1:])
plt.savefig("./stats/group_activity.png")
