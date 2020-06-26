#!/usr/bin/python3

"""Process CPU and MEM results from the file given as a command line argument.
CPU is expected to be the first entry on a given data line, while MEM is expected
to be the second."""

import statistics as stats
from sys import argv


with open(argv[1], 'r') as f:

    data_lines = [ line.split() for line in f.readlines() if "%" not in line ]
    cpus = [ float(data_line[0]) for data_line in data_lines ]
    mems = [ float(data_line[1]) for data_line in data_lines ]

    print(f"CPU mean: {stats.mean(cpus)}")
    print(f"CPU standard deviation: {stats.stdev(cpus)}")
    print(f"MEM mean: {stats.mean(mems)}")
    print(f"MEM standard deviation: {stats.stdev(mems)}")

