#!/bin/sh
#settings for first part of program
#this is what is used to remove characters that make rsync fail from the file and folder paths
sedvar='s/[\:\|\?\"]//g'
#settings for second part
#set origin
origin="/data/backup/backup_src/origin/"

#folder to copy them to (will append folder name to origin" e.g. "other_backup" will mean /data/backup/backup_src/other_backup
other_folder="other_backup/"

# things to copy to origin before backup
declare -A other_copying=( ["/data/backup/backup_src/other_origin/"]="${origin}${other_folder}another_folder/" )

#this cleans out 'weird' characters that sometimes makes rsync fail
#if you select "Just remove characters" this will happen immediately
#however if you set it to "Do all" this will happen after the "other_copying" 
#folders are copied to the origin
clean_origin=true
#this does the same thing to the other folders before copying it to origin:
clean_other_copying=false

#set destinations
basedest="/data/backup/backup_src/"
dests=( "${basedest}testdest1/" "${basedest}testdest2/" "${basedest}testdest3/"  "${basedest}testdest4/" )
rsync_opt1="-auv"
rsync_opt2="--delete-after"
backup_script_opt="--write-batch=backupscript" 
