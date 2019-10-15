#!/vendor/bin/sh
#
# Copyright (c) 2016, Motorola Mobility LLC,  All rights reserved.
#
# The purpose of this script is to get panic dump from pstore fs, and then
# save to emmc, and then reboot device.
#

export PATH=/vendor/bin:/system/bin:$PATH

# write log from pstore to "kpan" partition
kpreadwrite w
