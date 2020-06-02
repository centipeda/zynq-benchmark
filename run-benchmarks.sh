#!/bin/bash
# RUN-BENCHMARKS.sh
#
# Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git on a machine.
# Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.
# Unfortunately, you'll have to put the results into SubmittingReuslts.md yourself!
# This assumes that you have root access on this machine.


### THINGS THAT NEED WORK:
# - Generalization to non-x86 architectures and testing on them
# - Generalize script to support other versions of gcc (and testing!)


### CONSTANTS

THIS_DIR="$(pwd)"
SRC_DIR="./benchmark_src"
SCRIPTS_DIR="./benchmark_scripts"
DOWNLOAD_SOURCE="1"
MACHINE_NAME="$(hostname)"
CHECK_PACKAGES="0"
ARCH=$(uname -m)  # get this machine's architecture
GCC_V=6  # The version of gcc you intend to use
PROCESS_RESULTS="1"  # If you want to perform statistical analysis on benchmarking results
DRY_RUN="0"

# Automatically detect number of threads
if [ $(command -v nproc) ] ; then
  THREADS=$(nproc)
else
  THREADS=2
fi

function usage {
cat <<EOF
Usage: [sudo] $0

Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git.
Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.

Arguments:
-h, --help                    Display this message.

-g, --gcc <version>           Specify the version of devtoolset you want to use. The gcc within will
                              be used at all places in the benchmarking process needed.

-p, --process-results         Perform basic statistical analysis on benchmark scores
                              (mean, std. deviation). Python 3 will be installed if it isn't already.

-c, --check-pkgs              Checks if the required packages are installed using the yum package manager.

-d, --dry-run                 Don't run benchmarks, just check if requisite packages are installed.

-n, --network_test [ip addr]  Run iperf3 throughput test and ping latency test. Note the remote machine
                              must have the same version of iperf installed and be running in server mode
                              (iperf3 -s).

--no-download                 Don't attempt to download the Coremark source code from the Coremark GitHub
                              repository (assumes the code is present.) Will cause the script to fail if the
                              Coremark source is not present in $SRC_DIR/coremark.
EOF

exit $1
}



### SETUP

# Grabbed from https://unix.stackexchange.com/questions/122681/how-can-i-tell-whether-a-package-is-installed-via-yum-in-a-bash-script
function isinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

# Install and enable appropriate gcc
function check_pkgs_yum {

  echo "Activating correct version of gcc if not already active..."
  VERSION_STRING=" $GCC_V"  #FIXME: "is there a string in the gcc version output that starts with this number" is NOT good coding.
                            #       If you have a better idea, please submit a pull request.
  if [[ "$(gcc --version)" != *$VERSION_STRING* ]]; then
    echo "Requested version of gcc not active."
    echo "Installing appropriate devtoolset if not installed..."
    if ! isinstalled devtoolset-$GCC_V; then
      printf "Not installed. Installing now."
      yum -y install devtoolset-$GCC_V;  # This takes a while...
    else
      printf "Already installed."
    fi

    echo "Enabling devtoolset. This requires interrupting this program. Please run this file again."
    scl enable devtoolset-$GCC_V bash
    exit
  fi

  # Get git setup set up
  echo
  echo "Installing git if not installed..."
  if ! isinstalled git; then
    echo "Not installed. Installing now."
    yum -y install git;  # -y means answer yes to confirmations
  else
    echo "Already installed."
  fi
  git clone https://github.com/centipeda/zynq-benchmark.git

  # Install Python 3 if you will also be processing the benchmarking the reuslts on the system (this is easier)
  if [ $PROCESS_RESULTS ]; then
    echo "Installing python3 if not installed..."
    if ! isinstalled python3; then
      echo "Not installed. Installing now."
      yum -y install python3;
    else
      echo "Already installed."
    fi
  fi
}

### BENCHMARKING
function setup {
  echo "Creating directory $1..."
  mkdir -p $1
  echo "Attempting to update Coremark source..."
  if [ $DOWNLOAD_SOURCE == "1" ] ; then
    GIT_FAIL_MSSG="Failed to download Coremark source from GitHub."
    COREMARK_SRC_MSSG="If the source code is present in $SRC_DIR/coremark, run this script again with the --no-download flag to attempt to run Coremark anyway."
    git submodule update --init || echo $GIT_FAIL_MSSG $COREMARK_SRC_MSSG
  fi
}

# Record CPU and memory usage
function log_hw {
  echo "1" >> $2/benchmark_active.txt
  #echo "%CPU %MEM $(date)" >> ps.txt
  while [ $(tail -n 1 $2/benchmark_active.txt) == "1" ]
  do
    ps -o pcpu= -C $1 >> $2/ps.txt
    sleep 2
  done
}

function run_coremark {

  ## COREMARK
  echo "Running Coremark..."

  # if non-arm architecture, remove arm compiler flags from run file
  arm="-march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -march=armv7-a"
  if [ $ARCH != arm* ]; then
    arm=""
  fi

  args="XCFLAGS=\"-O3 -DMULTITHREAD=${THREADS} -DUSE_PTHREAD -lpthread -lrt ${arm}\""

  # Run coremark
  log_hw "coremark.exe" "$1" &
  for n in {1..10}
  do
      make -C $SRC_DIR/coremark clean
      make -C $SRC_DIR/coremark $args
      echo "Run #$n: $(tail -n 1 $SRC_DIR/coremark/run1.log)"
      tail -n 1 $SRC_DIR/coremark/run1.log >> $1/coremark.txt
  done

  # clean up
  echo "Cleaning Coremark source..."
  make -C $SRC_DIR/coremark clean

  echo "0" >> $1/benchmark_active.txt
}

function run_dhrystone {
  ## DHRYSTONE
  echo "Running Dhrystone benchmarks..."

  echo "Cleaning Dhrystone source..."
  make -C $SRC_DIR/dhrystone clean

  # Set Makefile variables.
  TIME_FUNC="-DTIME" # Might need to be "-DTIME" instead, depending on the system.
  if [ $ARCH == "arm" ]; then
    GCCOPTIM="-O -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16"
  else
    GCCOPTIM="-O -O3 -Ofast"
  fi

  echo "Compiling Dhrystone..."
  make -C $SRC_DIR/dhrystone TIME_FUNC="$TIME_FUNC" GCCOPTIM="$GCCOPTIM" all

  log_hw "gcc_dry2reg" "$1" &

  RUNS=10
  ITERS=100000000
  echo "Running Dhrystone, no registers..."
  for i in $( seq 1 $RUNS )
  do
    printf "run #$i: "
    echo $ITERS | $SRC_DIR/dhrystone/gcc_dry2 | tail -n 2 | head -n 1 | tee -a $1/dhrystone.txt
  done

  echo "Running Dhrystone with registers..."
  for i in $( seq 1 $RUNS )
  do
    printf "run #$i: "
    echo $ITERS | $SRC_DIR/dhrystone/gcc_dry2reg | tail -n 2 | head -n 1 | tee -a $1/dhrystone.txt
  done

  echo "Cleaning Dhrystone source..."
  make -C $SRC_DIR/dhrystone clean

  echo "0" >> $1/benchmark_active.txt
}

function run_whetstone {
  echo "Running Whetstone benchmarks..."

  # Set compiler flags
  if [ $ARCH == "arm" ]; then
    CFLAGS="-O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16 -DNDEBUG -lm"
  else
    CFLAGS="-O3 -Ofast -lm"
  fi

  echo "Compiling Whetstone..."
  make -C $SRC_DIR/whetstone CFLAGS="$CFLAGS" whetstone

  log_hw "whetstone" "$1" &
  LOOPS=1000000
  for n in {1..10}
  do
    printf "Run #$n: "
    $SRC_DIR/whetstone/whetstone $LOOPS | tail -n 1 | tee -a $1/whetstone.txt
  done

  echo "Cleaning Whetstone source directory..."
  make -C $SRC_DIR/whetstone clean

  echo "0" >> $1/benchmark_active.txt

}

function process_results {
  echo "Processing results.txt files using python3..."

  python3 $SCRIPTS_DIR/process_results.py coremark $1/coremark.txt | tee $1/results_summary.txt
  python3 $SCRIPTS_DIR/process_results.py dhrystone $1/dhrystone.txt | tee -a $1/results_summary.txt
  python3 $SCRIPTS_DIR/process_results.py whetstone $1/whetstone.txt | tee -a $1/results_summary.txt
}

function run_iperf {
  echo "Running iperf tests with remote IP address $REMOTE_IP"
  mkdir iperf
  cd iperf

  # UDP datagram size in bytes
  frame_size=1500
  step_size=2000

  while [ $frame_size -lt 65508 ]
  do
    echo "[" >> iperf_result_${frame_size}.json
    i=0
    while [ $i -lt 10 ]
    do
      # -b sets maximum bitrate in b/s (default is 1Mb/s); -Z uses "zero copy" to save CPU; man iperf3 for more
      iperf3 -c $REMOTE_IP -u -b 1000000000 -l $frame_size -J -Z >> iperf_result_${frame_size}.json
      echo "," >> iperf_result_${frame_size}.json
      i=$((i+1))
    done
    echo "]" >> iperf_result_${frame_size}.json
    frame_size=$((frame_size+step_size))
  done
  cd ..
}

function run_ping {
  echo "Testing latency using ping with remote IP address $REMOTE_IP"
  mkdir ping
  cd ping

  # So far, these are all ping defaults spelled out for configurability's sake
  PACKET_SIZE=56  # bytes
  NUM_PINGS=10  # number of times to ping server

  # No processing - ping is nice enough to do that for us
  ping -c $NUM_PINGS -s $PACKET_SIZE $REMOTE_IP >> ping_results.txt

  cd ..
}

function main {
  # if [ $# -eq 0 ]; then
  #   usage 1
  # fi

  while [ $# -gt 0 ]; do
    case $1 in
      -h|--help)
        usage 0
        ;;
      -g|--gcc)
        shift
        GCC="$1"
        ;;
      -p|--process-results)
        PROCESS_RESULTS="1"
        ;;
      -d|--dry-run)
        DRY_RUN="1"
        ;;
      -c|--check-pkgs)
        CHECK_PACKAGES="1"
        ;;
      --no-download)
        DOWNLOAD_SOURCE="0"
        ;;
      -n|--network-test)
        shift
        REMOTE_IP="$1"
        ;;
      *)
        MACHINE_NAME="$1"
        ;;
    esac
    shift
  done

  if [ $CHECK_PACKAGES == "1" ] ; then
    check_pkgs_yum
  fi


  RESULTS_DIR=$(date +"./${MACHINE_NAME}_results_%Y%m%d_%H%M%S")

  echo $0, $(date +"%Y-%m-%d %H:%M:%S"), selected parameters:
  echo "THIS_DIRECTORY:           $THIS_DIR"
  echo "SRC_DIRECTORY:            $SRC_DIR"
  echo "SCRIPTS_DIRECTORY:        $SCRIPTS_DIR"
  echo "RESULTS DIRECTORY:        $RESULTS_DIR"
  echo "CHECK_PACKAGES:           $CHECK_PACKAGES"
  echo "GCC_VERSION:              $GCC_V"
  echo "PROCESS_RESULTS:          $PROCESS_RESULTS"
  echo "DOWNLOAD_COREMARK_SOURCE: $DOWNLOAD_SOURCE"
  echo "DRY_RUN:                  $DRY_RUN"
  echo "THREADS:                  $THREADS"

  setup $RESULTS_DIR

  if [ $DRY_RUN -eq 0 ] ; then
    run_coremark
    run_dhrystone
    run_whetstone

    if [ $REMOTE_IP != "0" ]; then
      run_iperf
      run_ping
    fi

    # Process results.txt
    if [ $PROCESS_RESULTS != "0" ]; then
      process_results
    fi

  fi

  echo
  echo "Benchmarking process complete! The run results have been stored in $RESULTS_DIR."
  echo
}

main $@
