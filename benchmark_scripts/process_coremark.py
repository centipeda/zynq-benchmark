#!/usr/bin/python3

import statistics as stats

with open('results.txt') as resultFile:
    runs = [float(l.split(' ')[3]) for l in resultFile.readlines()]
    print("Run results: {}".format(runs))
    print("Mean: {}".format(stats.mean(runs)))
    print("Standard deviation: {}".format(stats.stdev(runs)))
