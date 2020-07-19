# CMS Trigger SOC Benchmarking 
This repo contains instructions for running the benchmarks: Coremark, Drhystone 2.1, and Whetstone on SOCs.  By all running these benchmarks with the same configuration we are able to make meaningful comparisons between devices.  A full discussion of these benchmarks and what their results mean is available in the [initial report](zynq_build/Zynq%20Benchmarking.pdf).  

To see all results to date, [view this table](https://centipeda.github.io/soc-benchmark).

To contribute your own results follow these instructions:

1. [Running Benchmarks](#running-benchmarks)
2. [Contributing results](./SubmittingResults.md)

Optionally, these instructions on [building Petalinux for a Zynq ](./zynq_build/BuildingPetaLinux.md) may serve to help you get started or replicate our initial environment.

# Running Benchmarks

## Prerequisites
* For all benchmarks:
    * `bash` for the benchmarking script
    * Python 3 and its standard library for basic statistical results, such as taking the average of the data and calculating its standard deviation
* For Whetstone, Dhrystone, and Coremark:
    * Git
    * Make
    * a C compiler (we use `gcc` here)
* For the ping and `iperf3` network tests:
    * An internet connection on the target device
* For the `iperf3` network test:
    * The `iperf3` binary
    * NumPy and matplotlib, for generating graphs of network performance
    * A second machine running `iperf3` in server mode

## Instructions

If you plan to submit a pull request to bring your benchmark results into the repository's [table](https://centipeda.github.io/soc-benchmark), [fork](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo) this repository and clone it locally. Otherwise, clone this repository to the computer you plan to run the benchmarks on.
After running the benchmarks, all results will be stored in a new directory named `$hostname_$date_$time/`. A new directory is created every time the benchmarking script is run. If you are planning to submit your scores to the upstream repository, please fill out the `information.txt` file created in the results directory before submitting your pull request.

More information on the command-line flags that can be used with the script can be found by using the `-h` (`--help`) flag:

```
$ ./run-benchmarks.sh --help
Usage: ./run-benchmarks.sh [args]
...
...
```

### Processor Benchmarks: Coremark, Whetstone, and Dhrystone
Execute `run-benchmarks.sh` with a command such as 
```
$ ./run-benchmarks.sh
./run-benchmarks.sh, 2020-06-17 20:31:53, selected parameters:
THIS_DIRECTORY:           .
SRC_DIRECTORY:            ./benchmark_src
SCRIPTS_DIRECTORY:        ./benchmark_scripts
RESULTS_DIRECTORY:        ./squiddy_results_20200617_203153
...
...
```

### Network Benchmarks: Ping and `iperf3`
To run the network tests, first start an `iperf3` in server mode on the machine you intend to test network connectivity to:
```
$ iperf3 -s
-----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```
Then, on the target machine (the one being benchmarked), execute the benchmarking script with either the `-n` (`--network-test`) or the `-j` (`--just-network`) flag:
```
$ ./run-benchmarks.sh --network-test 192.168.10.3
Testing network with iperf with remote IP address localhost...
...
...
```
