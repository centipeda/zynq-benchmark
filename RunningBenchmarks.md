### Running Benchmarks
**Requirements:**
1. Device is connected to the internet
2. git, make
3. gcc v6.2.1 \
   Check the correct version is installed using:
   ```
   $ gcc -v
   ```

**Compiler flags**
Since these benchmarks all involve the compiler, the nature of the compiler flags used can affect the benchmarking results to a great extent (Dhrystone and Whestone moreso than CoreMark.) As such, using the same compiler flags between runs and devices is important for getting comparable results. So as to enable comparison with [other benchmarks by Xilinx](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842551/Zc702+Benchmark), unless specified otherwise run the benchmarks with the following flags:
* `gcc` compiler flags: `-O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16 –DNDEBUG`, 

**CoreMark**

1. If you are connected to the internet, `git clone https://github.com/eembc/coremark` to get the [CoreMark repository](https://github.com/eembc/coremark). Otherwise, copy the contents of that repository to the root file system through some means. Internet access is not required to run the benchmark.
2. Enter the newly cloned repository, `coremark`.
3. To run the benchmark, use `make`. By default, the run logs are output to `run1.log` and `run2.log`. To use specific compiler flags, run `make` and set the XCFLAGS to a string with the flags. To keep with the [other Zynq CoreMark benchmarks that are available at the time of writing](https://www.eembc.org/coremark/view.php?benchmark_seq=2550,1473,1474,1418), we use the following set of compiler flags: ` -O3 -march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -DPERFORMANCE_RUN=1 -DMULTITHREAD=2 -DUSE_PTHREAD -lpthread -DPERFORMANCE_RUN=1 -lrt`.

`run1.log` records the performance run, and is where the actual benchmark results are stored. `run2.log` records the validation run, which ensures that CoreMark was run and finished properly. More details about CoreMark are available on the [EEMBC website](https://www.eembc.org/coremark/).

These results were obtained with the scripts in [benchmark_scripts/coremark](./benchmark_scripts/coremark). \
10-run sample results (iterations/second):
* Mean: 4961.007
* Standard Deviation: 0.94126


**Dhrystone 2.1**

Source code for the Dhrystone v2.1 benchmark was obtained from here: https://fossies.org/linux/privat/old/dhrystone-2.1.tar.gz/ \
Instructions adapted from: https://wiki.cdot.senecacollege.ca/wiki/Dhrystone_howto

1. Download and unpack the Dhrystone source tarball: `wget https://fossies.org/linux/privat/old/dhrystone-2.1.tar.gz/ && tar xzf dhrystone-2.1.tar.gz`
2. Make the following modifications to the `Makefile`: 
    * Comment out the line with `TIME_FUNC=  -DTIMES`
    * Uncomment the line with `TIME_FUNC=  -DTIME`
    * Add the necessary compiler flags after `GCCOPTIM=` (listed above, in our case)
3. Compile the benchmark with `make`.
4. Run the benchmark by running either `gcc_dry2` or `gcc_dry2reg`. The former program will not use registers, while the latter will.

These results were obtained with the scripts in [benchmark_scripts/dhrystone](./benchmark_scripts/dhrystone). \
10-run sample results, gcc_dry2reg:
* Mean: 3077651.5 Dhrystones/second
* Standard Deviation: 49909.7
* Mean, adjusted with VAX Dhrystones: 1751.651 VAX MIPS


10-run sample results, gcc_dry2:
* Mean:  3082912.4 Dhrystones/second
* Standard Deviation: 49909.7
* Mean, adjusted with VAX Dhrystones: 1754.654 VAX MIPS

**Whetstone** 

Source code for the Whetstone benchmark was obtained from here: https://www.netlib.org/benchmark/whetstone.c.

1. Download the Whetstone source code with something like `wget https://www.netlib.org/benchmark/whetstone.c`.
1. Compile the Whetstone source code with gcc, using `gcc whetstone.c [compiler flags] -lm -o whetstone`. 
 2. Run the benchmark by running `./whetstone [loop_count]`, where `[loop_count]` is the number of "loops" Whetstone performs. For our results, we used 1000000 loops, so the command to use is`whetstone 1000000`. To run the benchmark continuously, run `whetstone` with the `-c` flag.
3. The result of the benchmark is sent to stdout as "C Converted Double Precision Whetstones: `N` MIPS", where `N` is the raw benchmark score for the processor.


These results were obtained with the scripts in [benchmark_scripts/coremark](./benchmark_scripts/coremark). \
10-run sample results (Whetstones/second):
* Mean: 1462.08
* Standard Deviation: 10.99

### Notes
* If an error such as `XSCTHELPER INFO: Empty Workspace` appears during the build process, rebooting the build computer may resolve the issue.
* All benchmarks were run on a Zynq Z-7020 armv7 Cortex-A9 MPCore processor on a Mars PM3 evaluation board, with gcc version 6.2.1.
