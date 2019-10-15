#!/vendor/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/vendor/bin/}

[ "$1" == "-f" ] && FORCE=1

MID=`/vendor/bin/cat /sys/block/mmcblk0/device/manfid`
MID=${MID#0x0000}
if [ "$MID" != "15" ] ; then
  echo "Result: FAIL"
  echo "$SCRIPT: manufacturer not supported" > /dev/kmsg
  exit
fi
echo "Manufacturer: Samsung"

# Skip anything other than this model of Sandisk eMMC
PNM=`/vendor/bin/cat /sys/block/mmcblk0/device/name`
FIRMWARE_VERSION=`/vendor/bin/cat /sys/block/mmcblk0/device/firmware_version`
FIRMWARE_VERSION=${FIRMWARE_VERSION#0x}
FIRMWARE_DATA_PATH="/data/vendor/ffu"
FIRMWARE_DATA_FILE="${FIRMWARE_DATA_PATH}/${MID}_${PNM}_${FIRMWARE_VERSION}"
echo "Device Name: $PNM"
echo "Firmware Version: $FIRMWARE_VERSION"
UPDATE_PASS=0

# eMMC
#   - 32G TLC BWBD3R
#   - 64G TLC CWBD3R
# eMCP 5.1
#   - 16G eMMC + 24G LP3: RE1BMB
#   - 32G eMMC + 24G LP3: RX1BMB
#   - 32G eMMC + 32G LP3: RX14MB
#   - 64G eMMC + 24G LP3: RC1BMB
#   - 64G eMMC + 32G LP3: RC14MB
case "$PNM" in
  "BWBD3R" | "CWBD3R")
    if [ "$FIRMWARE_VERSION" -ge "2" ] ; then
      echo "Result: PASS"
      echo "$SCRIPT: firmware already updated" > /dev/kmsg
      exit
    fi
    ;;
  "RX1BMB" | "RX14MB" | "RC1BMB" | "RC14MB")
    if [ "$FORCE" == "1" -a "$FIRMWARE_VERSION" -eq "7" ] ; then
      if [ ! -d "$FIRMWARE_DATA_PATH" ] ; then
        echo "Result: FAILED"
        echo "$SCRIPT: unable to track updates" > /dev/kmsg
        exit
      fi
      # Force upgrade for all version 7 firmwares to flush out the bad ones.
      [ -e $FIRMWARE_DATA_FILE ] && UPDATE_PASS=`/vendor/bin/cat $FIRMWARE_DATA_FILE`
      UPDATE_PASS=$((10#$UPDATE_PASS + 1))
      if [ "$UPDATE_PASS" -gt "1" ] ; then
        echo "Result: PASSED"
        echo "$SCRIPT: one-pass update already completed" > /dev/kmsg
        exit
      fi
    elif [ "$FIRMWARE_VERSION" -ge "7" ] ; then
      echo "Result: PASS"
      echo "$SCRIPT: firmware already updated" > /dev/kmsg
      exit
    fi
    ;;

  # 16G eMMC only
  "RE1BMB" | "QE13MB" | "FE12MB")
    FIRMWARE_VERSION=`/vendor/bin/cat /sys/block/mmcblk0/device/firmware_version`
    version_delta=$(($FIRMWARE_VERSION - 0xd))
    if [ $version_delta -ge 0 ] ; then
      echo "Result: PASS"
      echo "$SCRIPT: firmware already updated" > /dev/kmsg
      exit
    fi
    ;;

  *)
    echo "Result: PASS"
    echo "$SCRIPT: no action required" > /dev/kmsg
    exit
    ;;
esac

if [ "$UPDATE_PASS" -gt "0" ] ; then
  echo "$SCRIPT: forcing one-time rev 7 upgrade" > /dev/kmsg
  # Stamp before the upgrade to make sure it gets there.
  echo $UPDATE_PASS > $FIRMWARE_DATA_FILE
  /vendor/bin/sync
fi

CID=`/vendor/bin/cat /sys/block/mmcblk0/device/cid`
PRV=${CID:18:2}
echo "Product Revision: $PRV"

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

echo "Result: PASS"
echo "$SCRIPT: firmware updated successfully" > /dev/kmsg
