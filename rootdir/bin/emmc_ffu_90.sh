#!/vendor/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/vendor/bin/}

MID=`/vendor/bin/cat /sys/block/mmcblk0/device/manfid`
if [ "$MID" != "0x000090" ] ; then
  echo "Result: FAILED"
  echo "$SCRIPT: manufacturer not supported" > /dev/kmsg
  exit
fi
echo "Manufacturer: Hynix"

PNM=`/vendor/bin/cat /sys/block/mmcblk0/device/name`
PNM=${PNM:0:5}  # Hynix puts an unprintable character at the end of PNM >:(
echo "Device Name: $PNM"

if [ "$PNM" == "H8G1e" -o "$PNM" == "HAG2e" ] ; then
  # Firmware update for Hynix eMCPs
  CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
  PRV=${CID:18:2}
  echo "Product Revision: $PRV"

  if [ "$PRV" -ge "08" ] ; then
    echo "Result: PASS"
    echo "$SCRIPT: no action required" > /dev/kmsg
    exit
  fi

  # Flash the firmware
  echo "Starting upgrade..."
  /vendor/bin/sync
  /vednor/bin/setprop vendor.need_ffu 1
  STATUS=$?
  
  if [ "$STATUS" != "0" ] ; then
    echo "Result: FAIL"
    echo "$SCRIPT: firmware update failed ($STATUS)" > /dev/kmsg
    exit
  fi
  
  sleep 1
  CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
  PRV=${CID:18:2}
  echo "New Product Revision: $PRV"

  echo "Result: PASS"
  echo "$SCRIPT: firmware updated successfully" > /dev/kmsg
elif [ "$PNM" == "HCG8e" ] ; then
  # Do the WP_GRP_SIZE fixup for this specific model 64GB Hynix eMMC
  CSD=`/vendor/bin/cat /sys/block/mmcblk0/device/csd`
  ERASE_GRP_SIZE=$(((16#${CSD:20:2} >> 2) & 0x1F))
  WP_GRP_SIZE=$((16#${CSD:22:2} & 0x1F))
  
  # If WP_GRP_SIZE matches ERASE_GRP_SIZE, this eMMC is OK
  if [ "$ERASE_GRP_SIZE" == "$WP_GRP_SIZE" ] ; then
    echo "Result: PASS"
    echo "$SCRIPT: suspect Hynix eMMC is OK" > /dev/kmsg
    exit
  fi
  
  CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
  PRV_ORIG=${CID:18:2}
  echo "Product Revision: $PRV_ORIG"
  
  # Reject this unit if the eMMC has the bug but is running some weird firmware
  if [ "$PRV_ORIG" != "03" ] ; then
    echo "Result: FAILED (unexpected PRV: $PRV_ORIG)"
    echo "$SCRIPT: unexpected PRV: $PRV_ORIG" > /dev/kmsg
    echo c > /proc/sysrq-trigger
    exit
  fi
  
  # Flash the fixup firmware
  /vendor/bin/sync
  /vednor/bin/setprop vendor.need_ffu 1
  STATUS=$?
  
  if [ "$STATUS" != "0" ] ; then
    echo "Result: FAIL"
    echo "$SCRIPT: fixup firmware update failed ($STATUS)" > /dev/kmsg
    exit
  fi
  
  sleep 1
  CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
  PRV_FIXUP=${CID:18:2}
  
  # Reject this unit if the eMMC is not running the fixup firmware as expected
  if [ "$PRV_FIXUP" != "f1" ] ; then
    echo "Result: FAILED (unexpected PRV after fixup FFU: $PRV_FIXUP)"
    echo "$SCRIPT: unexpected PRV after fixup FFU: $PRV_FIXUP" > /dev/kmsg
    echo c > /proc/sysrq-trigger
    exit
  fi
  
  # Flash the production firmware back on
  /vendor/bin/sync
  /vednor/bin/setprop vendor.need_ffu 1
  STATUS=$?
  
  if [ "$STATUS" != "0" ] ; then
    echo "Result: FAIL"
    echo "$SCRIPT: firmware restore failed ($STATUS)" > /dev/kmsg
    exit
  fi
  
  sleep 1
  CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
  PRV_FINAL=${CID:18:2}
  
  # Reject this unit if the eMMC is not running the original production firmware
  if [ "$PRV_FINAL" != "$PRV_ORIG" ] ; then
    echo "Result: FAILED (unexpected PRV after final FFU: $PRV_FINAL; expected: $PRV_ORIG)"
    echo "$SCRIPT: unexpected PRV after final FFU: $PRV_FINAL; expected: $PRV_ORIG" > /dev/kmsg
    echo c > /proc/sysrq-trigger
    exit
  fi
  
  CSD=`/vendor/bin/cat /sys/block/mmcblk0/device/csd`
  ERASE_GRP_SIZE=$(((16#${CSD:20:2} >> 2) & 0x1F))
  WP_GRP_SIZE=$((16#${CSD:22:2} & 0x1F))
  
  # Reject this unit if the eMMC still exhibits the bug
  if [ "$ERASE_GRP_SIZE" != "$WP_GRP_SIZE" ] ; then
    echo "Result: FAILED (WP_GRP_SIZE fixup unsuccessful: $WP_GRP_SIZE)"
    echo "$SCRIPT: WP_GRP_SIZE fixup unsuccessful: $WP_GRP_SIZE" > /dev/kmsg
    echo c > /proc/sysrq-trigger
    exit
  fi

  echo "Result: PASS"
  echo "$SCRIPT: successfully repaired Hynix WP_GRP_SIZE bug" > /dev/kmsg
else
  echo "Result: PASS"
  echo "$SCRIPT: no action required" > /dev/kmsg
  exit
fi
