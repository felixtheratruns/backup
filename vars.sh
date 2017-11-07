#!/bin/sh
#this gets the directory of this script for this example
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#settings for first part of program

#new vars from porter.sh
sedvar='s/[^a-zA-Z0-9_:\.\/\-]//g'

#this is what is used to remove characters that make rsync fail from the file and folder paths
sedvar='s/[\:\|\?\"]//g'
#settings for second part
#set origin
origin="$DIR/origin/"

#folder to copy them to (will append folder name to origin" e.g. "other_backup" will mean $DIR/other_backup
other_folder="other_backup/"

# things to copy to origin before backup
#declare -A other_copying=( ["$DIR/other_origin/"]="${origin}${other_folder}another_folder/" )

declare -A other_copying=()

#this cleans out 'weird' characters that sometimes makes rsync fail
#if you select "Just remove characters" this will happen immediately
#however if you set it to "Do all" this will happen after the "other_copying" 
#folders are copied to the origin
clean_origin=true
#this does the same thing to the other folders before copying it to origin:
clean_other_copying=false

#set destinations
basedest="$DIR/"
dests=( "${basedest}testdest1/" "${basedest}testdest2/" "${basedest}testdest3/"  "${basedest}testdest4/" )
rsync_opt1="-auv"
rsync_opt2="--delete-after"
backup_script_opt="--write-batch=backupscript" 
