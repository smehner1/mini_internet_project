import os
import csv

input_file="/tmp/group-mail-mapping.csv"

with open(input_file, 'r') as in_file:
    csv = csv.reader(in_file, delimiter=',')

    for g in csv:
        print(g)
        outfile="/tmp/mail-{}.txt".format(g[0])
        cmd="echo Subject: mini internet access - group {group} > {fi}".format(group=g[0], fi=outfile)
        os.system(cmd)
        cmd="./utils/write_emails.sh {group} >> {fi}".format(group=g[0], fi=outfile)           
        os.system(cmd)
        cmd="sendmail {} < {}".format(g[1], outfile)
        os.system(cmd)


        