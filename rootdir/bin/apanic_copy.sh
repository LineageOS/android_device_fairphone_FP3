#!/vendor/bin/sh
#
# Copyright (c) 2015, Motorola Mobility LLC,  All rights reserved.
#
# The purpose of this script is to read panic dumps to /data and dropbox
# for issue report
#

export PATH=/vendor/bin:/system/bin:$PATH

# read log from "kpan" partition to /data/dontpanic
kpreadwrite r
# write panic/wdt report to dropbox
kpgather

if [ -e /dev/block/bootdevice/by-name/logs ] ; then
    BL_logs_parti=/dev/block/bootdevice/by-name/logs
elif [ -e /dev/block/bootdevice/by-name/logfs ] ; then
    BL_logs_parti=/dev/block/bootdevice/by-name/logfs
else
    BL_logs_parti=
fi

if [ $BL_logs_parti ]
then
	cat $BL_logs_parti > /data/vendor/dontpanic/BL_logs
	chown root:log /data/vendor/dontpanic/BL_logs
	chmod 0640 /data/vendor/dontpanic/BL_logs
fi
