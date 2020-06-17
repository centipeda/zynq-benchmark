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

After running the benchmarks, all results will be stored in a new directory named `$hostname_$date_$time/`. A new directory is created every time the benchmarking script is run. More information on the command-line flags that can be used with the script can be found by using the `-h` (`--help`) flag:

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