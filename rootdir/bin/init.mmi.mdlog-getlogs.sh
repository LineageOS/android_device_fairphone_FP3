#!/vendor/bin/sh

getlogs_opts="/data/vendor/bug2go/getlogs.opts"
mdlog_user_opts="/data/vendor/diag_mdlog/user3.opts"
qdb_file="/firmware/image/qdsp6m.qdb"
qdb_file_alt="/vendor/firmware_mnt/image/qdsp6m.qdb"

arg_output="/data/vendor/bug2go/modem"
log_file=$arg_output/"getlogs.log"
mkdir $arg_output

# The output arg is fixed,
# use the cutomized opts from file if it exists
if [ -f $getlogs_opts ]; then
   args=`cat $getlogs_opts`
   # allow opts_file to be used only once
   mv -f $getlogs_opts $arg_output/
else
   # default value
   args="-b 209715200"
fi

diag_mdlog-getlogs -o $arg_output $args &> $log_file
if [ -f $mdlog_user_opts ]; then
    cp $mdlog_user_opts $arg_output/
fi

# copy qdsp6m.qdb
if [ -f $qdb_file ]; then
    cp $qdb_file $arg_output/
else
   # copy qdsp6m.qdb from alternate folder
   if [ -f $qdb_file_alt ]; then
       cp $qdb_file_alt $arg_output/
   fi
fi

