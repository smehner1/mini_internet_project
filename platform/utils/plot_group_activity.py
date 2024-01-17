#!/usr/bin/python3

import csv
import pandas as pd
import matplotlib.pyplot as plt


csv_file_hist_loc="./stats/group_activity_hist_loc.csv"
csv_file_login_count="./stats/group_activity_login_count.csv"
csv_file_login_duration="./stats/group_activity_login_duration.csv"
output="/var/www/html/stats/group_activity.png"

csv_files= [csv_file_hist_loc, csv_file_login_count, csv_file_login_duration]
# csv_files=[csv_file_login_duration]

# get group names form AS_config -> all groups with NoConfig

fig, ax = plt.subplots(3, 1, sharex=True, figsize=(8,8))

group_names=['date']

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

counter=0
for cur_csv in csv_files:
  if counter==0: ylabel="bash hist LOC"
  elif counter ==1: ylabel="login count"
  else: ylabel="logged in (min)"
  df = pd.read_csv(cur_csv, header=None, sep=" ")
  df.columns=group_names
  df['date']=pd.to_datetime(df['date'])
  print(df)
  df.set_index('date', inplace=True)
  df.plot.line(y=group_names[1:], ax=ax[counter], legend=False, ylabel=ylabel)
  counter+=1

ax[0].legend(loc='upper center', bbox_to_anchor=(0.5, 1.05),
          ncol=6, fancybox=True)
plt.suptitle("Group activity")
plt.tight_layout()
plt.savefig(output)
