#!/usr/bin/env python3
import os
import glob
import sys
import yaml
from collections import OrderedDict

RESULTS_BASE_DIR = sys.argv[1]
HEADERS = OrderedDict((
    ("coremark", "Coremark"),
    ("whetstone", "Whetstone"),
    ("dhrystone_with_registers", "Dhrystone, with registers"),
    ("dhrystone_without_registers", "Dhrystone, without registers")
))
INFO_HEADERS = OrderedDict((
    ("name", "Platform"),
    ("compiler", "Compiler"),
    ("cpu", "CPU"),
    ("date", "Date"),
    ("notes", "Notes"),
))

print("<table>")
print("  <tr>")
for header in INFO_HEADERS:
    print(f"    <th>{INFO_HEADERS[header]}</th>")
for header in HEADERS:
    print(f"    <th>{HEADERS[header]}</th>")
print("  </tr>")

for resultDir in os.listdir(RESULTS_BASE_DIR):
    infoFile = 'information.txt'

    print("  <tr>")
    try:
        with open(os.path.join(RESULTS_BASE_DIR, resultDir, infoFile), 'r') as info:
            information = yaml.load(info, Loader=yaml.BaseLoader)
            for header in INFO_HEADERS:
                print(f"    <td>{information[header]}</td>")
    except FileNotFoundError:
        print(f'No information file found in {os.path.join(RESULTS_BASE_DIR, resultDir, infoFile)}')

    summaryFiles = glob.glob(os.path.join(RESULTS_BASE_DIR, resultDir, '*summary.txt'))
    if summaryFiles:
        with open(summaryFiles[0]) as sFile:
            scores = yaml.load(sFile, Loader=yaml.BaseLoader)
            for header in HEADERS:
                print(f"    <td>{scores[header]['mean']}</td>")
    else:
        print(f'No summary file found in {os.path.join(RESULTS_BASE_DIR, resultDir, "*_summary.txt")}')
    print("  </tr>")

print("</table>")