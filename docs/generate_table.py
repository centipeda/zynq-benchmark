#!/usr/bin/env python3
import os
import glob
import sys
import yaml
from collections import OrderedDict

RESULTS_DIR = sys.argv[1]
HEADERS = OrderedDict((
    ("coremark", "Coremark"),
    ("whetstone", "Whetstone"),
    ("dhrystone_with_registers", "Dhrystone, with registers"),
    ("dhrystone_without_registers", "Dhrystone, without registers")
))

print("<table>")
print("  <tr>")
print("<th>Platform</th>")
for header in HEADERS:
    print(f"    <th>{HEADERS[header]}</th>")
print("  </tr>")

for resultDir in os.listdir(RESULTS_DIR):
    summaryFiles = glob.glob(os.path.join(RESULTS_DIR, resultDir, '*_summary.txt'))
    if summaryFiles:
        with open(summaryFiles[0]) as sFile:
            print("  <tr>")
            print(f"<td>{summaryFiles[0]}</td>")
            scores = yaml.load(sFile, Loader=yaml.BaseLoader)
            for header in HEADERS:
                print(f"    <td>{scores[header]['mean']}</td>")
            print("  </tr>")

    else:
        print(f'No summary file found in {os.path.join(RESULTS_DIR, resultDir, "*_summary.txt")}')

print("</table>")