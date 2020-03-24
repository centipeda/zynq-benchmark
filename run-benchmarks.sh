# RUN-BENCHMARKS
#
# Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git on a machine.
# Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.
#
# Put this file wherever you want the benchmarking repo and benchmarking directories to appear, then run it.
# (Or, just cd to a directory and copy paste the contents of this file.)
# This can be run twice consecutively without any problems.
# Unfortunately, you'll have to put the results into SubmittingReuslts.md yourself!
# This assumes that you have root access on this machine.


### CONSTANTS

ARCH="x86"  # if ARCH isn't "arm", alter some of the compilation flags in the repo
# GCC=6  # might add in GCC option later
PROCESS_RESULTS="1"  # If you want to install python3 and process results, "1", else, "0"


### SETUP

# Get git setup set up
yum -y install git  # -y means answer yes to confirmations
git clone https://github.com/centipeda/zynq-benchmark.git

# Install and enable appropriate devtoolset (Tom said to choose one, so I chose 6)
yum -y install devtoolset-6  # This takes a while...
scl enable devtoolset-6 bash
gcc --version  # should be 6.3.1

# Install Python 3 if you will also be processing the benchmarking the reuslts on the system (this is easier)
if [ $PROCESS_RESULTS != "0" ]; then
  yum -y install python3
fi


### BENCHMARKING

mkdir benchmarks
cp zynq-benchmark/benchmark_scripts benchmarks  # copy relevant repo dir into benchmarking dir
cd benchmarks

## COREMARK
git clone https://github.com/eembc/coremark
mv benchmark_scripts/coremark/run_coremark.sh run_coremark.sh
cd coremark

# if non-arm architecture, remove arm compiler flags from run file
if [ $ARCH != "arm" ]; then
  sed -i 's/-march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -march=armv7-a //' run_coremark.sh 
fi
run_coremark.sh

# Process results.txt
if [ $PROCESS_RESULTS != "0" ]; then
  mv benchmark_scripts/coremark/process_coremark.py process_coremark.py
  python3 process_coremark.py >> results_summary.txt
fi

cd ..

## DHRYSTONE
mkdir dhrystone
cd dhrystone
curl https://fossies.org/linux/privat/old/dhrystone-2.1.tar.gz > dhrystone-2.1.tar.gz
tar xzf dhrystone-2.1.tar.gz

# Make edits to the Makefile
sed -i 's/#TIME_FUNC=     -DTIME/TIME_FUNC=     -DTIME/'  # uncomment this line...
sed -i 's/TIME_FUNC=     -DTIMES/#TIME_FUNC=     -DTIMES/'  # ...comment out this line.
# add compiler flags
if [ $ARCH == "arm" ]; then
  sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16/'
else
  sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O3 -Ofast/'
fi

mv benchmark_scripts/dhrystone/run_dhrystone.sh run_dhrystone.sh
run_dhrystone.sh

# Process results.txt
if [ $PROCESS_RESULTS != "0" ]; then
  mv benchmark_scripts/dhrystone/process_dhrystone.py process_dhrystone.py
  python3 process_dhrystone.py >> results_summary.txt
fi

cd ..

## WHETSTONE
mkdir whetstone
cd whetstone
curl https://www.netlib.org/benchmark/whetstone.c > whetstone.c

mv benchmark_scripts/whetstone/run_whetstone.sh run_whetstone.sh
run_whetstone.sh

# Process results.txt
if [ $PROCESS_RESULTS != "0" ]; then
  mv benchmark_scripts/whetstone/process_whetstone.py process_whetstone.py
  python3 process_whetstone.py >> results_summary.txt
fi

cd ..

