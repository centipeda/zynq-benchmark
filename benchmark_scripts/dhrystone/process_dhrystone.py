#!/usr/bin/python3
import statistics as stats

with open('results.txt') as resultFile:
    lines = resultFile.readlines()
    noRegDry = [float(l.split(' ')[-10]) for l in lines[1:11]]
    regDry = [float(l.split(' ')[-10]) for l in lines[14:]]


    print("Dhrystone with registers run results: {}".format(noRegDry))
    print("Mean: {} Dhrystones per second".format(stats.mean(noRegDry)))
    print("Standard deviation: {}".format(stats.stdev(noRegDry)))
    print("Mean VAX Dhrystones per second: {} DMIPS".format(stats.mean([x / 1757 for x in noRegDry])))

    print("Dhrystone without registers run results: {}".format(regDry))
    print("Mean: {} Dhrystones per second".format(stats.mean(regDry)))
    print("Standard deviation: {}".format(stats.stdev(regDry)))
    print("Mean VAX Dhrystones per second: {} DMIPS".format(stats.mean([x / 1757 for x in regDry])))
