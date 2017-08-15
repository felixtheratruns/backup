#!/bin/sh
#settings for first part of program
sedvar='s/[\:\|\?\"]//g'
#settings for second part
#set origin
origin="/data/backup/backup_src/origin/"

#folder to copy them to (will append folder name to origin" e.g. "other_backup" will mean /data/backup/backup_src/other_backup
other_folder="other_backup/"

# things to copy to origin before backup
declare -A other_origins=( ["/home/joel/"]="${origin}${other_folder}home_folder/" )

#set destinations
basedest="/data/backup/backup_src/"
dests=( "${basedest}testdest1/" "${basedest}testdest2/" "${basedest}testdest3/"  "${basedest}testdest4/" )
rsync_opt="-auv --delete-after"
backup_script_opt="--write-batch=backupscript" 


