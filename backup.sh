#!/bin/sh

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# 1 The first part of this script is used to prepare for an rysnc backup by getting rid of the following characters:
# : | ? "
# i.e. colon, pipe, questionmark, doublequote

# 2 The seccond part of this program does the actual backup

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


#settings for first part of program
sedvar='s/[\:\|\?\"]//g'

#settings for second part
#set origin
origin="/data/org/"
#set destinations
dests=( "/mnt/hd1/" "/mnt/hd2/" )

rsync_options="-azts" 

echo "Regex used to remove characters before rsync:" $sedvar
echo "Rsync options:" "$rsync_options"
echo ""
echo "Rsync folders:"
count=1
 


if [ -d "$origin" ]; then
  exists="Exists"
else
  exists="DOES NOT EXIST!!!"
fi

echo "Origin: " $origin $exists

for destdir in ${dests[@]}; do
  if [ -d "$destdir" ]; then
    exists="Exists"
  else
    exists="DOES NOT EXIST!!!"
  fi
  echo "$count""Destination: $destdir $exists"
  ((count+=1))
done

read -p "Are you sure you want to continue with this information? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi



read -p "1 does all, 2 just does character remove, 3 just does rsync" -n 1 -r
echo
case "$REPLY" in
1)  echo "Doing all"
    rep_chars=true        
    rsync_data=true
    ;;
2)  echo "Just characters"
    rep_chars=true        
    rsync_data=false
    ;;
3)  echo "Just rsync"
    rep_chars=false        
    rsync_data=true
    ;;
*) echo "Not an option"
   ;;
esac




if "$rep_chars"
then
echo "start replace filenames"

#depth shows subdirectories before their parent and hence prevents 
#the mv command from moving subdirectories to non-existent directies (ie becasue their parent dir was renamed)
#basename is needed to prevent cases where a directory is attempted moved because it's parent dir is changed by sed so it thinks the directories are different but it's parent is going to be renamed later 
#anyway (so directories are actually renamed in order of greadest depth to least depth)
#but this does not show up in the find commands results so it causes the "mv" command to throw an error


find "$origin" -depth -type d -name '*' -exec bash -c '
    echo -e "doing directories: \n"
    for dir do
        bdir=`basename "$dir"`
        rdir=`echo "$dir" | sed '$sedvar'`        
        brdir=`basename "$rdir"`
        if [[ "$bdir" != "$brdir" ]]
            then
            echo "mv"
            echo "1:" "===$dir==="
            echo "2:" "===$rdir==="
            mv "$dir" "$rdir"
            echo "..."
        fi
    done
' bash {} + 

#now do the same for files
#you might be able to combine the two
#I just like to split things up
find "$origin" -type f -name '*' -exec bash -c '
    echo -e "doing files: $file \n"
    for file do 
        rfile=`echo "$file" | sed '$sedvar'`
        if [[ "$file" != "$rfile" ]]
            then
            echo "mv"
            echo "1:" "===$file==="
            echo "2:" "===$rfile==="
            mv "$file" "$rfile"
            echo "..."
        fi    
    done
' bash {} +
fi


if "$rsync_data"
then

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
echo "starting rsync"
for dest in ${dests[@]}; do 
  echo "origin:" $origin  
  echo "dest:" $dest
	rsync "$rsync_options" "$origin" "$dest"
done
IFS=$SAVEIFS

fi
