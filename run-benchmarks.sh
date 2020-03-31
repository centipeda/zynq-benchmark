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

ARCH="x86"  # if ARCH isn't "arm", alter some of the compilation flags in the repo
GCC_V=6  # The version of gcc you intend to use
PROCESS_RESULTS=0  # If you want to install python3 and perform statistical analysis on benchmarking results
DRY_RUN=0

function usage {
cat <<EOF
Usage: $(basename $0) [MACHINE_NAME]

Runs benchmarks from https://github.com/centipeda/zynq-benchmark.git.
Follows the procedure specified in https://github.com/centipeda/zynq-benchmark/blob/master/RunningBenchmarks.md.

Put this file wherever you want the benchmarking repo and benchmarking directories to appear, then run it.
(Or, just cd to a directory and copy paste the contents of this file.)
This can be run twice consecutively without any problems.
Unfortunately, you'll have to put the results into SubmittingReuslts.md yourself!
This assumes that you have root access on this machine.

Arguments:
-h, --help                 Display this message.

-a, --arch ARCHITECTURE    Set compiler arguments to those for ARCHITECTURE.
                           Currently supported: "x86" and "arm".

-p, --process-results      Perform basic statistical analysis on benchmark scores
                           (mean, std. deviation). Requires Python 3 to be installed.

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
  printf "\nActivating correct version of gcc if not already active...\n"
  VERSION_STRING="gcc (GCC) $GCC_V"

  if [[ "$(gcc --version)" != *$VERSION_STRING* ]]; then  # I know this is hacky, but it's the only way I could think to do it
    printf "\nRequested version of gcc not active."
    printf "Installing appropriate devtoolset if not installed..."
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
  printf "\nInstalling git if not installed..."
  if ! isinstalled git; then
    printf "Not installed. Installing now."
    yum -y install git;  # -y means answer yes to confirmations
  else
    printf "Already installed."
  fi
  git clone https://github.com/centipeda/zynq-benchmark.git

  # Install Python 3 if you will also be processing the benchmarking the reuslts on the system (this is easier)
  if [ $PROCESS_RESULTS ]; then
    printf "\nInstalling python3 if not installed...\n"
    if ! isinstalled python3; then
      printf "Not installed. Installing now."
      yum -y install python3;
    else
      printf "Already installed."
    fi
  fi
}

### BENCHMARKING
function setup {
  mkdir benchmarks
  cp -r zynq-benchmark/benchmark_scripts benchmarks  # copy relevant repo dir into benchmarking dir
  cd benchmarks
}

function run_coremark {
  ## COREMARK
  printf "\nRunning Coremark benchmarks.\n"
  rm -rf coremark  # if there is a directory here already, we want it gone.
  git clone https://github.com/eembc/coremark
  cd coremark
  mv ../benchmark_scripts/coremark/run_coremark.sh run_coremark.sh

  # if non-arm architecture, remove arm compiler flags from run file
  if [ $ARCH != "arm" ]; then
    sed -i 's/-march=armv7-a -mcpu=cortex-a9 -mfpu=neon-fp16 -march=armv7-a //' run_coremark.sh 
  fi

  # Run coremark
  sh run_coremark.sh

  # Process results.txt
  if [ $PROCESS_RESULTS != "0" ]; then
    mv ../benchmark_scripts/coremark/process_coremark.py process_coremark.py
    python3 process_coremark.py >> results_summary.txt
  fi

  cd ..
}

function run_dhrystone {
  ## DHRYSTONE
  printf "\nRunning Dhrystone benchmarks.\n"
  rm -rf dhrystone  # if there is a directory here already, we want it gone.
  mkdir dhrystone
  cd dhrystone
  curl https://fossies.org/linux/privat/old/dhrystone-2.1.tar.gz > dhrystone-2.1.tar.gz
  tar xzf dhrystone-2.1.tar.gz

  # Edit dhry_1.c (https://stackoverflow.com/questions/9948508/errors-while-compiling-dhrystone-in-unix)
  # Comment out a few lines to prevent conflicting function definitions...
  sed -i 's/extern char     \*malloc ();/\/\/ extern char     \*malloc ();/' dhry_1.c
  sed -i 's/extern  int     times ();/\/\/ extern  int     times ();/' dhry_1.c
  # ...and add back in some stdlib function definitions
  sed -i '1i #include <stdio.h>' dhry.h
  sed -i '1i #include <string.h>' dhry.h

  # Edit Makefile
  sed -i 's/#TIME_FUNC=     -DTIME/TIME_FUNC=     -DTIME/' Makefile  # uncomment this line...
  sed -i 's/TIME_FUNC=     -DTIMES/#TIME_FUNC=     -DTIMES/' Makefile  # ...comment out this line.
  # add compiler flags
  if [ $ARCH == "arm" ]; then
    sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16/' Makefile
  else
    sed -i 's/GCCOPTIM=       -O/GCCOPTIM=       -O -O3 -Ofast/' Makefile
  fi

  # Make
  make

  # Finally, FINALLY run dhrystone
  mv ../benchmark_scripts/dhrystone/run_dhrystone.sh run_dhrystone.sh
  sh run_dhrystone.sh

  # Process results.txt
  if [ $PROCESS_RESULTS != "0" ]; then
    mv ../benchmark_scripts/dhrystone/process_dhrystone.py process_dhrystone.py
    python3 process_dhrystone.py >> results_summary.txt
  fi

  cd ..
}

function run_whetstone {
  ## WHETSTONE
  printf "\nRunning Whetstone benchmarks.\n"
  rm -rf whetstone  # if there is a directory here already, we want it gone.
  mkdir whetstone
  cd whetstone
  curl https://www.netlib.org/benchmark/whetstone.c > whetstone.c

  # Make and then run whetstone
  if [ $ARCH == "arm" ]; then
    gcc whetstone.c -O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16 –DNDEBUG -lm -o whetstone
  else
    gcc whetstone.c -O3 -Ofast -lm -o whetstone
  fi
  mv ../benchmark_scripts/whetstone/run_whetstone.sh run_whetstone.sh
  sh run_whetstone.sh

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
      -a|--arch)
        shift
        ARCH="$1"
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

  # check_pkgs
  # setup
  # run_coremark
  # run_dhrystone
  # run_whetstone
  # printf "\nBenchmarking process complete! Find the results inside of results.txt and results_summary.txt in each folder."
  # printf "Exiting program.\n\n"
}

main $@