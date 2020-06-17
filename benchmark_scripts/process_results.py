#!/usr/bin/env python3

import sys
import statistics as stats

target = sys.argv[1]
resultFile = sys.argv[2]

with open(resultFile) as f:
    if target == 'coremark':
        runs = [float(l.split(' ')[3]) for l in f.readlines()]
        print("--- Coremark Results ---")
        print("Run results: {}".format(runs))
        print("Mean: {}".format(stats.mean(runs)))
        print("Standard deviation: {}".format(stats.stdev(runs)))
    elif target == 'whetstone':
        runs = [float(l.split(' ')[-2]) for l in f.readlines()]
        print("--- Whetstone Results ---")
        print("Run results: {}".format(runs))
        print("Mean: {}".format(stats.mean(runs)))
        print("Standard deviation: {}".format(stats.stdev(runs)))
    elif target == 'dhrystone':
        lines = f.readlines()
        num_runs = 10
        noRegDry = [float(l.split()[-1]) for l in lines[1:num_runs+1]]
        regDry = [float(l.split()[-1]) for l in lines[num_runs+4:]]
        print("--- Dhrystone Results ---")
        print("Dhrystone with registers run results: {}".format(noRegDry))
        print("Mean: {} Dhrystones per second".format(stats.mean(noRegDry)))
        print("Standard deviation: {}".format(stats.stdev(noRegDry)))
        print("Mean VAX Dhrystones per second: {} DMIPS".format(stats.mean([x / 1757 for x in noRegDry])))
        print("Dhrystone without registers run results: {}".format(regDry))
        print("Mean: {} Dhrystones per second".format(stats.mean(regDry)))
        print("Standard deviation: {}".format(stats.stdev(regDry)))
        print("Mean VAX Dhrystones per second: {} DMIPS".format(stats.mean([x / 1757 for x in regDry])))
    elif target == 'hardware':
        runs = [float(line.strip()) for line in f]
        print("--- Hardware Monitoring Results ---")
        print("Run results: {}".format(runs))
        print("Mean: {}".format(stats.mean(runs)))
        print("Standard deviation: {}".format(stats.stdev(runs)))