#!/usr/bin/python3
import statistics as stats

with open('whetstone.txt', 'r') as f:
    runs = [float(line.strip()) for line in f]
    print("Run results: {}".format(runs))
    print("Mean: {}".format(stats.mean(runs)))
    print("Standard deviation: {}".format(stats.stdev(runs)))
