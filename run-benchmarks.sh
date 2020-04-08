# RUN-BENCHMARKS.sh
#
# Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git on a machine.
# Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.
#
# Put this file wherever you want the benchmarking repo and benchmarking directories to appear, then run it.
# (Or, just cd to a directory and copy paste the contents of this file.)
# This can be run twice consecutively without any problems.
# Unfortunately, you'll have to put the results into SubmittingReuslts.md yourself!
# This assumes that you have root access on this machine.


### THINGS THAT NEED WORK:
# - Generalization to non-x86 architectures and testing on them
# - Generalize script to support other versions of gcc (and testing!)


### CONSTANTS

ARCH=$(arch)  # get this machine's architecture
GCC_V=6  # The version of gcc you intend to use
PROCESS_RESULTS=0  # If you want to install python3 and perform statistical analysis on benchmarking results
DRY_RUN=0

function usage {
cat <<EOF
Usage: (sudo) $(basename $0) [GCC VERSION]

Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git.
Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.

Put this file wherever you want the benchmarking repo and benchmarking directories to appear, then run it.
(Or, just cd to a directory and copy paste the contents of this file.)
This can be run twice consecutively without any problems.
Unfortunately, you'll have to put the results into SubmittingReuslts.md yourself!
This assumes that you have root access on this machine.

Arguments:
-h, --help                 Display this message.

-g, --gcc                  Specify the version of devtoolset you want to use. The gcc within will
                           be used at all places in the benchmarking process needed.

-p, --process-results      Perform basic statistical analysis on benchmark scores
                           (mean, std. deviation).Python 3 will be installed if it isn't already.

-d, --dry-run              Don't run benchmarks, just check if requisite packages are installed.
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
function check_pkgs {

  echo "Activating correct version of gcc if not already active..."
  VERSION_STRING=" $GCC_V"  #FIXME: "is there a string in the gcc version output that starts with this number" is NOT good coding. Sorry.

  if [[ "$(gcc --version)" != *$VERSION_STRING* ]]; then  # I know this is hacky, but it's the only way I could think to do it
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
  mkdir benchmarks
  cp -r zynq-benchmark/benchmark_scripts benchmarks  # copy running dir into benchmarks
  cp -r zynq-benchmark/benchmark_src benchmarks  # copy benchmarks src dir into benchmarks 
  cd benchmarks
}

# Record CPU and memory usage
function log_hw {
  echo "1" >> benchmark_active.txt
  #echo "%CPU %MEM $(date)" >> ps.txt
  while [ $(tail -n 1 benchmark_active.txt) == "1" ]
  do
    ps -o pcpu= -C $1 >> ps.txt
    sleep 2
  done
}

function run_coremark {
  ## COREMARK
  echo "Running Coremark benchmarks."
  rm -rf coremark  # if there is a directory here already, we want it gone.
  git clone https://github.com/eembc/coremark
  cd coremark
  mv ../benchmark_scripts/coremark/run_coremark.sh run_coremark.sh

  # if non-arm architecture, remove arm compiler flags from run file
  if [ $ARCH != arm* ]; then
    sed -i 's/-march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -march=armv7-a //' run_coremark.sh 
  fi

  # Run coremark
  log_hw "coremark.exe" &
  sh run_coremark.sh
  echo "0" >> benchmark_active.txt

  # Process results.txt
  if [ $PROCESS_RESULTS != "0" ]; then
    mv ../benchmark_scripts/coremark/process_coremark.py process_coremark.py
    python3 process_coremark.py >> results_summary.txt
  fi

  cd ..
}

function run_dhrystone {
  ## DHRYSTONE
  echo "Running Dhrystone benchmarks."
  rm -rf dhrystone  # if there is a directory here already, we want it gone.
  mv benchmark_src/dhrystone/ .  # get predownloaded dhrystone source
  cd dhrystone

  # Edit Makefile
  sed -i 's/#TIME_FUNC=     -DTIME/TIME_FUNC=     -DTIME/' Makefile  # uncomment this line...
  sed -i 's/TIME_FUNC=     -DTIMES/#TIME_FUNC=     -DTIMES/' Makefile  # ...comment out this line.
  # add compiler flags
  if [ $ARCH == "arm" ]; then
    sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16/' Makefile
  else
    sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O -O3 -Ofast/' Makefile
  fi

  # Make and run
  make
  mv ../benchmark_scripts/dhrystone/run_dhrystone.sh run_dhrystone.sh
  log_hw "gcc_dry2reg" &
  sh run_dhrystone.sh
  echo "0" >> benchmark_active.txt

  # Process results.txt
  if [ $PROCESS_RESULTS != "0" ]; then
    mv ../benchmark_scripts/dhrystone/process_dhrystone.py process_dhrystone.py
    python3 process_dhrystone.py >> results_summary.txt
  fi

  cd ..
}

function run_whetstone {
  ## WHETSTONE
  echo "Running Whetstone benchmarks."
  rm -rf whetstone  # if there is a directory here already, we want it gone.
  mv benchmark_src/whetstone/ .  # get predownloaded whetstone source
  cd whetstone

  # Make and then run whetstone
  if [ $ARCH == "arm" ]; then
    gcc whetstone.c -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16 -DNDEBUG -lm -o whetstone
  else
    gcc whetstone.c -O3 -Ofast -lm -o whetstone
  fi
  mv ../benchmark_scripts/whetstone/run_whetstone.sh run_whetstone.sh
  log_hw "whetstone" &
  sh run_whetstone.sh
  echo "0" >> benchmark_active.txt

  # Process results.txt
  if [ $PROCESS_RESULTS != "0" ]; then
    mv ../benchmark_scripts/whetstone/process_whetstone.py process_whetstone.py
    python3 process_whetstone.py >> results_summary.txt
  fi

  cd ..
}

function main {
  if [ $# -eq 0 ]; then
    usage 1
  fi

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
        PROCESS_RESULTS=1
        ;;
      --dry-run)
        DRY_RUN=1
        ;;
      *)
        MACHINE_NAME="$1"
        ;;
    esac
    shift
  done

  check_pkgs
  setup
  run_coremark
  run_dhrystone
  run_whetstone

  echo
  echo "Benchmarking process complete! Find the results inside of results.txt and results_summary.txt in each folder. CPU and memory usage are in ps.log in each folder. Note that CPU usage is computed as the percentage of CPU time used over the lifetime of the process."
  echo "Exiting program."
  echo
}

main $@
