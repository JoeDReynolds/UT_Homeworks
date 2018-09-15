import os
import csv
import numpy as np
from collections import Counter

file = "Resources/election_data.csv"

candidate = []

with open(file, newline = '') as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ',')
    csv_header = next(csvreader)
    for row in csvreader:
        candidate.append(row[2])
        
total_votes = len(candidate)

unique_candidates = list(set(candidate))

lib_cand = (Counter(candidate)).keys()
lib_votes = (Counter(candidate)).values()

cand = list(lib_cand)
votes= list(lib_votes)

perc_vote = [(x / total_votes)*100 for x in votes]

rd_per_vote = ["%.3f" % x for x in perc_vote]
hi_vote = max(votes)
win_index = votes.index(hi_vote)
winner = cand[win_index]

roster = zip(cand, votes, rd_per_vote)

output_file = os.path.join("output.csv")

with open(output_file, "w", newline="") as datafile:
    writer = csv.writer(datafile)
    writer.writerow(["Candidate", "Votes", "% of Vote"])
    writer.writerows(roster)
    
file2 = "../PyPoll/output.csv"

print("Election Results")
print("-------------------------")
print("Total Votes: " + str(total_votes))
print("-------------------------")


with open(file2, newline = '') as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ',')
    csv_header = next(csvreader)
    for row in csvreader:
        print(str(row[0]) + ": " + str(row[2]) +"% (" + str(row[1]) +")" )
    
print("-------------------------")
print("Winner: " + winner)
print("-------------------------")

f = open("PYpoll.txt", 'w', newline ="")
f.write("Election Results \n")
f.write("------------------------- \n")
f.write("Total Votes: " + str(total_votes) + '\n')
f.write("-------------------------" + '\n')


with open(file2, newline = '') as csvfile:
    csvreader = csv.reader(csvfile, delimiter = ',')
    csv_header = next(csvreader)
    for row in csvreader:
        f.write(str(row[0]) + ": " + str(row[2]) +"% (" + str(row[1]) +")\n" )
    
f.write("-------------------------\n")
f.write("Winner: " + winner + '\n')
f.write("-------------------------\n")
f.close()