#!/usr/bin/python3

import statistics as stats
import sys

with open() as f:
    runs = [float(l.split(' ')[3]) for l in f.readlines()]
    print("Run results: {}".format(runs))
    print("Mean: {}".format(stats.mean(runs)))
    print("Standard deviation: {}".format(stats.stdev(runs)))
