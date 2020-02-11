#! /bin/bash -ex

# Usage: ./create_project.sh <project_name>

# Author: Peter Wittich, Cornell University
# Minor modifications made by Joshua Cepeda, @centipeda

# Prerequisites:
#  1. petalinux v2017.4 installed in /opt/petalinux
#  2. source /opt/petalinux/settings.sh
#  3. source /opt/petalinux/components/yocto/source/aarch64/environment-setup-aarch64-xilinx-linux
#  4. export PATH=/opt/petalinux/components/yocto/source/aarch64/layers/core/bitbake/bin:$PATH

#BASEDIR=/mnt/scratch/wittich/tracklet/firmware/TrackletProject/YUGE/BoardTest/Zynq2/MarsZX2_6089_101_revA
# I'm assuming that your cwd is here
BASEDIR=`pwd`
HDW=${BASEDIR}/Vivado/Vivado_PM3/MarsZX2_PM3.sdk

DIR=$1
[ -d $DIR ] && (echo $DIR already exists; exit 1)


petalinux-create -t project --template zynq --name $1
cd $1
petalinux-config --get-hw-description=${HDW}

##Removed because ubuntu doesn't know what "konsole" is
cat >> project-spec/meta-user/conf/petalinuxbsp.conf <<EOF
OE_TERMINAL = "konsole"
EOF


# EDIT such that the device tree file looks like this
cat > project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi <<EOF
/include/ "system-conf.dtsi"
/ {
};
/{
  chosen {
          bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rw rootwait uio_pdrv_genirq.of_id=\"generic-uio\"";
  };
};
&gem0 {
            phy-handle = <&phy0>;
            ps7_ethernet_0_mdio: mdio {
                 phy0: phy@3 {
                    device_type = "ethernet-phy";
                    reg = <3>;
                 };
            };
};
&flash0 {
   compatible = "s25fl512s";
   spi-tx-bus-width = <0x1>;
   spi-rx-bus-width = <0x4>;
};
&i2c0 {
	status = "okay";
        // RTC on the enclustra board
	pcf85063: pcf85063@51 {
		status = "okay";
		compatible = "nxp,pcf85063";
		reg = <0x51>;
	};
        // eeprom on YUGE
        at24@84 {
                status = "okay";
                compatible = "atmel,at24c01";
                reg = <0x54>;
        };
};
&i2c1 {
       status = "okay";
       // various i2c power supplies, use generic drivers
       // these are the ones directly connected to the Zynq
       // select via AXI registers
       // will need to update for devices off FPGA
       // PMBUS ADDRESS: 0x20, NOT STUFFED
       // REFDES: U6
       // hwmon@32 {
       //         status = "okay";
       //         compatible = "pmbus";
       //         reg = <32>;
       //};
       // PMBUS ADDRESS: 0x21,
       // REFDES: U8
       hwmon@33 {
                status = "okay";
                compatible = "pmbus";
                reg = <33>;
       };
       // PMBUS ADDRESS: 0x23
       // REFDES: U1
       hwmon@35 {
                status = "okay";
                compatible = "pmbus";
                reg = <35>;
       };
       // PMBUS ADDRESS: 0x24
       // REFDES: U2
       hwmon@36 {
                status = "okay";
                compatible = "pmbus";
                reg = <36>;
       };
};
&sdhci0 {
       // need to prevent the SD card from mounting as read-only, if we're using
       // a persistent filesystem on the SD card
       status = "okay";
       disable-wp; 
};
EOF
#Note that for the gem0, the actual compatible line is commented out.

petalinux-config -c kernel
#this is to enable Micrel PHY support (not as a module, built into kernel)
#Navigate to kernel configuration -> Device Drivers -> Network device support ->PHY Device and Infrastructure -> Micrel PHY
#exit the config
#This generates a file under project-spec and some directories there, not sure if you can just do it w/o the kernel config

echo "if the command below fails you did not update the kernel for the MICREL phy."

ls project-spec/meta-user/recipes-kernel/linux/linux-xlnx/
#user_2017-10-20-10-47-00.cfg
# values currently set in the custom kernel beyond the defaults
# CONFIG_MICREL_PHY=y -- for Ethernet PHY on the ZX2
# CONFIG_SPI_SPIDEV=y -- probably not needed?
# CONFIG_UIO_PDRV_GENIRQ=y -- for xvcServer
# CONFIG_UIO_DMEM_GENIRQ=y -- probably not needed
# CONFIG_RTC_DRV_PCF85063=y -- RTC on ZX2

echo "Configure root filesystem to add packages: "
# so we can add packages (ex., benchmarking requires make and gcc)
petalinux-config -c rootfs 

#Need to add this to config to get ethernet to work
cat >> project-spec/meta-user/recipes-kernel/linux/linux-xlnx/user_*.cfg <<EOF
CONFIG_KSZ9031=y
EOF

cat >> project-spec/meta-user/recipes-bsp/u-boot/files/platform-top.h <<EOF
#undef CONFIG_PREBOOT
#define CONFIG_PREBOOT	"echo U-BOOT for YUGE;setenv preboot; echo;env import -t 0xFFFFFC00;dhcp"
EOF

petalinux-build

# Copy our patched FSBL code from the Enclustra design reference
cp ${BASEDIR}/patched_zx2_ref_fsbl/src/* components/plnx_workspace/fsbl/fsbl/src

# Recompile with patched FSBL. I know, there's a better way to do this...
petalinux-build

petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga images/linux/system_top.bit --u-boot  --kernel --force

#Note that this latter step will put all the relevant files in images/linux

#% cp BOOT.bin images/linux/image.ub <sd card boot partition>

# success! The PHY appears both to the u-boot and to the kernel

# For a new SD card it must be formatted with two partitions

# 1. the first partition must be FAT and at least 64 MB, and bootable
# 2. the second partition can be ext4 and take up the rest of the card.

# the default project sets the root file system to an INITRAMFS
# to tell the kernel to use a persistent root file system, must set 
# configuration setting in petalinux-config
