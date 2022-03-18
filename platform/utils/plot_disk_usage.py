#!/usr/bin/python3

import pandas as pd
import matplotlib.pyplot as plt

csv_file="./stats/disk_usage.csv"

df = pd.read_csv(csv_file, header=None, names=["date", "disk", "inode"], sep=" ")
df['date']=pd.to_datetime(df['date'])


df.set_index('date').plot.line(y=["disk" ,"inode"], title="Disk Usage", ylabel="%")


plt.savefig("/var/www/html/stats/disk_usage.png")