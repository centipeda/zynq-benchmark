# zynq-benchmark
Build tools to build Linux images for and benchmark the Mars ZX2 SoC module. `create_project.sh` adapted from script written by Peter Wittich at Cornell University, with minor modifications.

### Build instructions
1. Install the Petalinux build chain. Activate it with `source /opt/petalinux/settings.sh`, or wherever it is installed.
2. Clone this repository.
3. Run `./create_project.sh [project_name]`, where `[project_name]` is the name of the directory you want to place the project files in.
4. After some time, the script will open into the kernel configuration menu.
5. To configure the kernel to use a persistent file system, go to `General Setup --> [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support` and disable it (set to `[]`).
6. To enable Ethernet support (for the ZX2 on the Mars PM3), go to `Device Drivers --> Network Device Support --> PHY Device support and infrastructure --> [] Micrel PHYs` and enable it as built into the kernel (`[*]`, not `[M]`).
7. Save the new kernel configuration (TAB to scroll through the bottom menu options), and exit.
8. After some time, the script will open into the root file system configuration menu.
9. To compile build tools such as `gcc` and `make` (necessary for running the CoreMark benchmark), go to `Filesystem Packages --> misc --> packagegroup-core-buildessential --> [] packagegroup-core-buildessential` and enable it.
10. To compile `git` into the image, go to `Filesystem Packages --> console --> utils --> [] git` and enable it.
11. Enable other packages as needed. Press `/` to search for packages.
12. Wait for script to build and package image files. All output files should be placed into `images/linux`.

### Boot instructions
(Assuming the ZX2 is on the Mars PM3 interface board, which has a MicroSD slot and serial UART port):
1. Using your partition editor of choice, create two partitions on a MicroSD card: the first should be offset from the beginning of the card by 4MB, at least 64MB in size, and FAT-formatted. Name this partition `boot`. The second partition can take up the rest of the space on the MicroSD card, and should be formatted as ext4. Name this partition `rootfs`.
2. Mount the MicroSD card.
3. From the `images/linux` folder, copy `image.ub` and `BOOT.BIN` to the `boot` partition.
4. From the same folder, extract the root file system to the `rootfs` partition with `tar xzf rootfs.tar.gz -C /path/to/rootfs`.
5. Unmount the MicroSD card, and place it into the board's SD card slot.
6. Ensure the board's DIP switches are configured for SD card boot. On the Mars PM3, this is such that switches 1 on both sets of switches are set to ON, and all others are set to OFF.
7. Connect an Ethernet cable to the board if you wish to connect to the Internet.
8. Connect a MicroUSB cable (with a data line!) to the MicroUSB port on the board. Connect the other end to the computer you are connecting from. The orange TX/RX lights should light up briefly to signal a connection has been made.
9. Open a serial console on the communication port the board connects to -- on Windows it is usually `COM4`, and on Linux it is usually `/dev/ttyUSB0`.The board is set to communicate at a baud rate of 115200. Some serial consoles on Windows are PuTTY and the built-in serial console, and `screen` can be used on Linux to open a serial console with `sudo screen /dev/ttyUSB0 115200`.
10. Power the board. The PWR light should turn on, and the ZX2 should begin to send log messages to the serial console.
11. It should now be possible to log into the ZX2 via the serial console. The default username is `root` with password `root`.

### Benchmarking
While logged into the ZX2, check to make sure the desired packages were built in successfully with `which gcc`, `which git`, etc. If not, it may be necessary to rebuild the image.

Since these benchmarks all involve the compiler, the nature of the compiler flags used can affect the benchmarking results to a great extent (Dhrystone and Whestone moreso than CoreMark.) As such, using the same compiler flags between runs and devices is important for getting comparable results. All of the following benchmarks were run with the following `gcc` compiler flags: `-O3 -Ofast --mcpu=cortex-a9 -mfpu=vfpv3-fp16 –DNDEBUG`, to keep with [other benchmarks by Xilinx](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842551/Zc702+Benchmark).

**CoreMark**

1. If you are connected to the internet, `git clone https://github.com/eembc/coremark` to get the [CoreMark repository](https://github.com/eembc/coremark). Otherwise, copy the contents of that repository to the root file system through some means. Internet access is not required to run the benchmark.
2. Enter the newly cloned repository, `coremark`.
3. To run the benchmark, use `make`. By default, the run logs are output to `run1.log` and `run2.log`.

More details about the benchmark are available at https://www.eembc.org/coremark/.

**Dhrystone 2.1**

Source code for the Dhrystone v2.1 benchmark was obtained from here: https://github.com/Keith-S-Thompson/dhrystone/tree/master/v2.1.


**Whetstone** 

Source code for the Whetstone benchmark was obtained from here: https://www.netlib.org/benchmark/whetstone.c.

1. Download the Whetstone source code with something like `wget https://www.netlib.org/benchmark/whetstone.c`.
1. Compile the Whetstone source code with gcc, using `gcc whetstone.c -o whetstone`.
2. Run the benchmark by executing `whetstone`. The number of "loops" the program performs to benchmark can be passed as a command line argument, as `whetstone 1000000`. To run the benchmark continuously, use `whetstone -c`.
3. The result of the benchmark is sent to stdout as "C Converted Double Precision Whetstones: `foo` MIPS", where `foo is the raw benchmark score for the processor.

### Notes
* If an error such as `XSCTHELPER INFO: Empty WorkSpace` comes up during the build process, rebooting the build computer may resolve the issue.
* The "CoreMark Score" reported on the EEMBC website is the "Iterations/Sec" seen in the CoreMark run logs.
