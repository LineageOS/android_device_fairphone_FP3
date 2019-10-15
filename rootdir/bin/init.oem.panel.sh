#!/vendor/bin/sh

PATH=/sbin:/vendor/sbin:/vendor/bin:/vendor/xbin
export PATH

while getopts s: op;
do
	case $op in
		s)  supplier=$OPTARG;;
	esac
done
shift $(($OPTIND-1))

scriptname=${0##*/}

notice()
{
	echo "$*"
	echo "$scriptname: $*" > /dev/kmsg
}

notice "panel supplier is [$supplier]"
case $supplier in
	boe | tianmah)
		insmod /vendor/lib/modules/himax_mmi.ko
		;;
	tianman)
		insmod /vendor/lib/modules/nova_mmi.ko
		;;
	tianma)
		insmod /vendor/lib/modules/synaptics_tcm_i2c.ko
		insmod /vendor/lib/modules/synaptics_tcm_core.ko
		insmod /vendor/lib/modules/synaptics_tcm_touch.ko
		insmod /vendor/lib/modules/synaptics_tcm_device.ko
		insmod /vendor/lib/modules/synaptics_tcm_reflash.ko
		insmod /vendor/lib/modules/synaptics_tcm_testing.ko
		;;
	*)
		notice "$supplier not supported"
		return 1
		;;
esac

return 0