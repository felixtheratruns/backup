#!/bin/sh
#settings for first part of program
sedvar='s/[\:\|\?\"]//g'

#settings for second part
#set origin
origin="/data/org/backup/origin/"
#set destinations
basedest="/data/org/backup/"
dests=( "${basedest}testdest1/" "${basedest}testdest2/" "${basedest}testdest3/"  "${basedest}testdest4/" )
rsync_options="--write-batch=backupscript" 
rsync_options2="-azs"


