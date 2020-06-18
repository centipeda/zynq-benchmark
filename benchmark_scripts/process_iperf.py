#!/usr/bin/env python3

import numpy as np
import json
import statistics as stats
import matplotlib.pyplot as plt
from sys import argv

# empty lists for the results
bps = []
jitter = []
cpu_host = []
cpu_remote = []
loss = []
bps_err = []
jitter_err = []
cpu_host_err = []
cpu_remote_err = []
loss_err = []


frame_size = np.arange(1500,65501,2000)
iperf_dir = argv[1]
iperf_plot_dir = "{}/plots".format(iperf_dir)

for fs in frame_size:
    filename = "{}/iperf_result_{}.json".format(iperf_dir, str(fs))
    print(filename)
    with open(filename, "r") as f:
        f_read = f.read()

        # Slice out the trailing comma
        f_read = f_read[:-4] + "]"
        data = json.loads(f_read)
        b = []
        ch = []
        cr = []
        j = []
        l = []
        for i in data:
            b.append(i["end"]["sum"]["bits_per_second"])
            ch.append(i["end"]["cpu_utilization_percent"]["host_total"])
            cr.append(i["end"]["cpu_utilization_percent"]["remote_total"])
            j.append(i["end"]["sum"]["jitter_ms"])
            l.append(i["end"]["sum"]["lost_percent"])
        bps.append((stats.mean(b))/1000000)
        bps_err.append((stats.stdev(b))/1000000)
        cpu_host.append(stats.mean(ch))
        cpu_host_err.append(stats.stdev(ch))
        cpu_remote.append(stats.mean(cr))
        cpu_remote_err.append(stats.stdev(cr))
        jitter.append(stats.mean(j))
        jitter_err.append(stats.stdev(j))
        loss.append(stats.mean(l))
        loss_err.append(stats.stdev(l))

# Make the actual plots
fig, ax = plt.subplots()
ax.errorbar(frame_size,bps,bps_err,fmt="ro")
ax.set_xlabel("UDP Packet Size (B)")
ax.set_ylabel("Throughput (Mb/s)")
ax.set_title("UDP: Throughput vs. Packet Size")
plt.savefig("{}/bps.png".format(iperf_dir))

fig, ax = plt.subplots()
ax.errorbar(frame_size,loss,loss_err,fmt="ro")
ax.set_xlabel("UDP Packet Size (B)")
ax.set_ylabel("Loss (%)")
ax.set_title("UDP: Packet Loss vs. Packet Size")
plt.savefig("{}/loss.png".format(iperf_dir))

fig, ax = plt.subplots()
ax.errorbar(frame_size,jitter,jitter_err,fmt="ro")
ax.set_xlabel("UDP Packet Size (B)")
ax.set_ylabel("Jitter (ms)")
ax.set_title("UDP: Jitter vs. Packet Size")
plt.savefig("{}/jitter.png".format(iperf_dir))

fig, ax = plt.subplots()
ax.errorbar(frame_size,cpu_host,cpu_host_err,fmt="ro")
ax.set_xlabel("UDP Packet Size (B)")
ax.set_ylabel("CPU Sender (%)")
ax.set_title("UDP: Sender CPU Usage vs. Packet Size")
plt.savefig("{}/cpu_host.png".format(iperf_dir))

fig, ax = plt.subplots()
ax.errorbar(frame_size,cpu_remote,cpu_remote_err,fmt="ro")
ax.set_xlabel("UDP Packet Size (B)")
ax.set_ylabel("CPU Receiver (%)")
ax.set_title("UDP: Receiver CPU Usage vs. Packet Size")
plt.savefig("{}/cpu_remote.png".format(iperf_dir))

