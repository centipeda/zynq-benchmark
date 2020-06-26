#!/usr/bin/env python3

import sys
import statistics as stats
import argparse

parser = argparse.ArgumentParser(description="""
    Process the benhcmarks run by the benchmarking script. Outputs in YAML format.
    """
)
parser.add_argument("-c", "--coremark-file", help="""
    The file containing the output from a set of Coremark runs. This should contain
    a series of lines of data, each one from the last line of the run1.log file created by each
    run of Coremark.
    """)
parser.add_argument("-w", "--whetstone-file", help="""
    The file containing the output from a set of Whetstone runs.
""")
parser.add_argument("-d", "--dhrystone-file", help="""
    The file containing the output from a set of Dhrystone runs.
""")
parser.add_argument("-o", "--output-file", help="File to save summary to. Will default to stdin.")
args = parser.parse_args()
summary = ""
processing = False

if args.coremark_file:
    processing = True
    # print(f'Processing Coremark results in {args.coremark_file}')
    with open(args.coremark_file) as coremarkFile:
        runs = [float(l.split(' ')[3]) for l in coremarkFile.readlines()]
        summary += f"""
coremark_summary:
    raw_data: {runs}
    mean: {stats.mean(runs)}
    standard_deviation: {stats.stdev(runs)}
    units: coremark/s
        """
if args.whetstone_file:
    processing = True
    # print(f'Processing Whetstone results in {args.whetstone_file}')
    with open(args.whetstone_file) as whetstoneFile:
        runs = [float(l.split(' ')[-2]) for l in whetstoneFile.readlines()]
        summary += f"""
whetstone_summary:
    raw_data: {runs}
    mean: {stats.mean(runs)}
    standard_deviation: {stats.stdev(runs)}
    units: whetstones/s
        """
if args.dhrystone_file:
    processing = True
    # print(f'Processing Dhrystone results in {args.dhrystone_file}')
    with open(args.dhrystone_file) as dhrystoneFile:
        data = [d.strip() for d in dhrystoneFile.readlines()]
        numRuns = len(data)//2
        noRegs = [float(d.split()[-1]) for d in data[0:numRuns]]
        regs = [float(d.split()[-1]) for d in data[numRuns:]]
        summary += f"""
dhrystone_registers_summary:
    raw_data: {regs}
    mean: {stats.mean(regs)}
    standard_deviation: {stats.stdev(regs)}
    units: dhrystones/s

dhrystone_no_registers_summary:
    raw_data: {noRegs}
    mean: {stats.mean(noRegs)}
    standard_deviation: {stats.stdev(noRegs)}
    units: dhrystones/s
        """

if processing:
    print(summary)
    if args.output_file:
        with open(args.output_file, 'a') as outFile:
            outFile.write(summary)
exit()

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