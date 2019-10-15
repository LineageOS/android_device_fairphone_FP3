#!/vendor/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/vendor/bin/}

MID=`/vendor/bin/cat /sys/block/mmcblk0/device/manfid`
MID=${MID#0x0000}

# If we have an upgrade script for this manufactuer, execute it.
if [ -x /vendor/bin/emmc_ffu_${MID}.sh ] ; then
  /vendor/bin/sh /vendor/bin/emmc_ffu_${MID}.sh
else
  echo "Manufacturer: Other"
  echo "Result: PASS"
  echo "$SCRIPT: no action required" > /dev/kmsg
fi
