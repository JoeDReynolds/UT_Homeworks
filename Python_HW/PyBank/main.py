import os
import csv
import numpy as np

file = "Resources/budget_data.csv"

month = []
profit = []


with open(file, newline = '') as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ',')
    csv_header = next(csvreader)
    for row in csvreader:
        month.append(row[0])
        profit.append(row[1])
month_count = len(month)
int_profit = list(map(int, profit))
sum_profit = sum(int_profit)

prof_dif = list(np.diff(int_profit))

avg_prof_dif = sum(prof_dif)/len(prof_dif)
rd_av_prof_dif = ("%.2f" % avg_prof_dif)
big_inc = max(prof_dif)
big_dec = min(prof_dif)

inc_ind = prof_dif.index(big_inc)
dec_ind = prof_dif.index(big_dec)

month_inc = month[inc_ind + 1]
month_dec = month[dec_ind + 1]

print("Financial Analysis")
print("----------------------------")
print("Total Months: " + str(month_count))
print("Total: $" + str(sum_profit))
print("Average Change: $" + str(rd_av_prof_dif))
print("Greatest Increase in Profits " + str(month_inc) + " ($" + str(big_inc) + ')')
print("Greatest Decrease in Profits " + str(month_dec) + " ($" + str(big_dec) + ')')

f = open("PYbank.txt", 'w', newline ="")
f.write("Financial Analysis\n")
f.write("----------------------------\n")
f.write("Total Months: " + str(month_count) + "\n")
f.write("Total: $" + str(sum_profit) + '\n')
f.write("Average Change: $" + str(rd_av_prof_dif) + '\n')
f.write("Greatest Increase in Profits " + str(month_inc) + " ($" + str(big_inc) + ')' + '\n')
f.write("Greatest Decrease in Profits " + str(month_dec) + " ($" + str(big_dec) + ')' + '\n')
f.close()