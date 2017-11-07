#!/bin/sh
#settings for first part of program
#old vars with tilder untested
#sedvar='s/[\:\|\?\"\~]//g'
#old vars without tilde tested
#sedvar='s/[\:\|\?\"]//g'

#new vars from porter.sh
sedvar='s/[^a-zA-Z0-9_:\.\/\-]//g'

#settings for second part
#set origin
origin="/mnt/hd1/data/"
#set destinations
basedest="/mnt/hd2"
dests=( "${basedest}/data" )
#dests=(  "${basedest}hd2/org/" )
rsync_options="--write-batch=backupscript" 
rsync_options2="-avu --delete"


