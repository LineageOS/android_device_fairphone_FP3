#!/vendor/bin/sh
#
# Copyright (c) 2013-2015, Motorola LLC  All rights reserved.
#

SCRIPT=${0#/vendor/bin/}

[ "$1" == "-f" ] && FORCE=1

MID=`cat /sys/block/mmcblk0/device/manfid`
MID=${MID#0x0000}
echo ${MID}
if [ "$MID" != "13" ] ; then
  echo "emmc_ffu_13.sh Result: FAIL"
  echo "$SCRIPT: manufacturer not supported" > /dev/kmsg
  exit
fi
echo "Manufacturer: Micron"

# Skip anything other than this model of
# Mircron is S0J97Y, S0J9K8,S0J9N8
PNM=`cat /sys/block/mmcblk0/device/name`
FIRMWARE_VERSION=`cat /sys/block/mmcblk0/device/fwrev`



echo "Device Name: $PNM"

#0x3341514d30305244
#0x3644454d30305353 test FW
#0x3333484d30305357 offical FW
#5357 = 21335
#544e = 21582
#564e = 22094

case "$PNM" in
  "S0J97Y")
     FIRMWARE_VERSION=${FIRMWARE_VERSION#0x3}
     FIRMWARE_VERSION=${FIRMWARE_VERSION:0-4:4}
     FIRMWARE_VERSION_HEX=(0x$FIRMWARE_VERSION)
     FIRMWARE_VERSION_DEC=$((FIRMWARE_VERSION_HEX))
     echo "$SCRIPT:Firmware Version: $FIRMWARE_VERSION" > /dev/kmsg
     echo "device version: $DEVICE_VERSION" > /dev/kmsg
     if [ "$FIRMWARE_VERSION_DEC" -ge "22094" ] ; then
        echo "Result: PASS"
        echo "$SCRIPT: firmware already updated" > /dev/kmsg
        exit
     fi
     ;;
  "S0J9K8" | "S0J9N8")
     FIRMWARE_VERSION=${FIRMWARE_VERSION#0x0}
     FIRMWARE_VERSION=${FIRMWARE_VERSION:0:1}
     FIRMWARE_VERSION_HEX=(0x$FIRMWARE_VERSION)
     FIRMWARE_VERSION_DEC=$((FIRMWARE_VERSION_HEX))
     # get device version
     DEVICE_VERSION=`cat /sys/block/mmcblk0/device/device_version`
     DEVICE_VERSION=${DEVICE_VERSION#0x0}
     DEVICE_VERSION=${DEVICE_VERSION:0:1}
     echo "$SCRIPT:Firmware Version: $FIRMWARE_VERSION" > /dev/kmsg
     echo "$SCRIPT:device version: $DEVICE_VERSION" > /dev/kmsg
     if [ "$FIRMWARE_VERSION" -eq "4"  ] && [ "$DEVICE_VERSION" -eq  "3" ] ; then
        echo "Starting upgrade $PNM"
     else
        echo "$SCRIPT: firmware ${FIRMWARE_VERSION}${DEVICE_VERSION} updated successfully" > /dev/kmsg
        exit
     fi
     ;;
   *)
     echo "Result: pass"
     echo "$SCRIPT : no action required" > dev/kmsg
     exit
    ;;
esac

# Flash the firmware
echo "Starting upgrade..."
case "$PNM" in
   "S0J97Y")
      /system/bin/sync
      /system/bin/emmc_ffu -yR

      STATUS=$?

      if [ "$STATUS" != "0" ] ; then
         echo "Result: FAIL"
         echo "$SCRIPT: firmware update failed ($STATUS)" > /dev/kmsg
         exit
    fi

    echo "Result: PASS"
    echo "$SCRIPT: firmware updated successfully" > /dev/kmsg
    /system/bin/sync
    ;;

    "S0J9K8" | "S0J9N8")
      echo "vendor $PNM firmware version ${FIRMWARE_VERSION}${DEVICE_VERSION} start emmc_ffu"
      /vendor/bin/sync
      /vendor/bin/setprop vendor.need_ffu 1

      STATUS=$?

      if [ "$STATUS" != "0" ] ; then
           echo "setprop  vendor.need_ffu failed"
           echo "$SCRIPT: setprop vendor.need_ffu failed" > /dev/kmsg
           exit
      fi
      echo "setprop vendor.need_ffu successfully"
      echo "$SCRIPT: setprop vendor.need_ffu successfully" > /dev/kmsg
     ;;
esac
