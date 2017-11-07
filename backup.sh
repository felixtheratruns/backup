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

if [ "$1" = 'run' ]; then
    run_status=1
else
    run_status=0
fi

#if [ "$(id -u)" != "0" ]; then
#   echo "This script must be run as root" 1>&2
#   exit 1
#fi

rot(){
    declare cmnd="${*}"
    declare ret_code 
    #this if there are quotes arround password: 
    #echo "$value"|sed 's/password="[^"]*"/password="XXXXX"/' >> somelog.log 

#    if [[ "$showpass" = 0 ]]; then
#        local cmnd_np=$(echo "$cmnd" | sed 's/password=[^ ]*/password=XXXXX/')
#    else
#        local cmnd_np="$cmnd"
#    fi

    cmnd_np="$(printf "$cmnd"|tr '\n' ' ')"

    if [ "$run_status" = 1  ]; then
        printf "command=\n\"$cmnd_np\"\n\n" 
        #`$cmnd`
        output=$($cmnd)
        ret_code=$?
        printf "output=\n\"$output\"\n\n"
        printf "\n\n"
        if [ $ret_code != 0 ]; then
            printf "Error: ['$ret_code'] when executing command: '$cmnd_np'\n\n"
            exit $ret_code
        fi
    elif [ "$run_status" = 0 ]; then
        printf "test=$cmnd_np" 
        printf "\n\n"
    else
        printf "invalid run status: $run_status"
        printf "\n\n"
    fi
}
. vars.sh


#rot cp "-f" "/home/joel/test1" "/home/joel/test2"


##settings for first part of program
#sedvar='s/[\:\|\?\"]//g'
#
##settings for second part
##set origin
#origin="/data/org/backup/origin/"
##set destinations
#basedest="/data/org/backup/"
#dests=( "${basedest}testdest1/" "${basedest}testdest2/" "${basedest}testdest3/"  "${basedest}testdest4/" )
#rsync_options="--write-batch=backupscript" 
#rsync_options2="-azs"

#echo "Regex used to remove characters before rsync:" $sedvar
#echo "Rsync options:" "$rsync_opt"
#echo ""
#echo "Rsync folders:"

function doesItExist(){
    local __resultvar=$1
    local folder=$2
    local custom_message1=$3
    local custom_message2=$4
    exists=''
    if [ -d "$folder" ]; then
        exists="Exists"
        if [ -n "$custom_message1" ]; then
            exists=$custom_message1
        fi
    else
        exists="DOES NOT EXIST!!!"
        if [ -n "$custom_message2" ]; then
            exists=$custom_message2
        fi
    fi
    eval $__resultvar="'$exists'"
}


#declare -A test_copying=( ["moo"]="moooooo" )
#
#          
#for i in "${}"
#do
#    
#done

#see if other copying exists
exists=""
echo "First script will copy:"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for i in "${!other_copying[@]}"
do  
    echo "$i"
    echo "to:"
    doesItExist exists "${other_copying[$i]}" "" "does not exist, will be created"
    echo "${other_copying[$i]}" "$exists"
    echo ""
done
IFS=$SAVEIFS

#see if destinations exist
count=1
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for destdir in ${dests[@]}; do
    exists=""
    doesItExist exists "$destdir"  
    echo "$count""Destination: $destdir $exists"
    ((count+=1))
done
IFS=$SAVEIFS
#read -p "Are you sure you want to continue with this information? " -n 1 -r
#echo    # (optional) move to a new line
#if [[ ! $REPLY =~ ^[Yy]$ ]]
#then
#    exit 1
#fi

read -p "0 Stops 1 does all, 2 just does character remove, 3 just does rsync" -n 1 -r
echo
case "$REPLY" in
1)  echo "Do all"
    rep_chars=true        
    rsync_data=true
    doing_all=true
    ;;
2)  echo "Just remove characters"
    rep_chars=true        
    rsync_data=false
    just_characters=true
    ;;
3)  echo "Just rsync"
    rep_chars=false        
    rsync_data=true
    just_rsync=true
    ;;
0)  echo "Stop"
    exit 1
    ;;
*) echo "Not an option"
   ;;
esac


function cleanOrigin(){    
    local org=$1
    echo "cleaning origin: $org"

    if [ $run_status = 1 ]; then  
        find "$org" -depth -type d -name '*' -exec bash -c '
            echo -e "doing directories: \n"
            for dir do
                bdir=`basename "$dir"`
                rdir=`echo "$dir" | sed '$sedvar'`        
                brdir=`basename "$rdir"`
                if [[ "$bdir" != "$brdir" ]]
                    then
                    echo "mv"
                    echo "1:" "$dir"
                    echo "2:" "$rdir"
                    mv "$dir" "$rdir"
                    echo ". . ."
                fi
            done
        ' bash {} + 
        #now do the same for files
        #you might be able to combine the two
        #I just like to split things up
        find "$org" -type f -name '*' -exec bash -c '
            echo -e "doing files: $file \n"
            for file do 
                rfile=`echo "$file" | sed '$sedvar'`
                if [[ "$file" != "$rfile" ]]
                    then
                    echo "mv"
                    echo "1:" "$file"
                    echo "2:" "$rfile"
                    mv "$file" "$rfile"
                    echo ". . ."
                fi    
            done
        ' bash {} +
    elif [ $run_status = 0 ]; then
        find "$org" -depth -type d -name '*' -exec bash -c '
            echo -e "doing directories: \n"
            for dir do
                bdir=`basename "$dir"`
                rdir=`echo "$dir" | sed '$sedvar'`        
                brdir=`basename "$rdir"`
                if [[ "$bdir" != "$brdir" ]]
                    then
                    echo mv "$dir" "$rdir"
                fi
            done
        ' bash {} + 
        #now do the same for files
        #you might be able to combine the two
        #I just like to split things up
        find "$org" -type f -name '*' -exec bash -c '
            echo -e "doing files: $file \n"
            for file do 
                rfile=`echo "$file" | sed '$sedvar'`
                if [[ "$file" != "$rfile" ]]
                    then
                    echo mv "$file" "$rfile"
                fi    
            done
        ' bash {} +
    fi 
}


is_origin_clean=false
if "$rep_chars"
then
#    echo "start replace filenames"
    #depth shows subdirectories before their parent and hence prevents 
    #the mv command from moving subdirectories to non-existent directies (ie becasue their parent dir was renamed)
    #basename is needed to prevent cases where a directory is attempted moved because it's parent dir is changed by sed so it thinks the directories are different but it's parent is going to be renamed later 
    #anyway (so directories are actually renamed in order of greadest depth to least depth)
    #but this does not show up in the find commands results so it causes the "mv" command to throw an error

    if [ "$clean_other_copying" = true ] ; then
        SAVEIFS=$IFS
        IFS=$(echo -en "\n\b")
        for other_org in "${!other_copying[@]}"
        do  
            if [ -n "${other_org}"  ]; then
                echo cleanOrigin "${other_org}" 
                cleanOrigin "${other_org}" 
            fi
        done
        IFS=$SAVEIFS
    fi

    if [ "$clean_origin" = true ] && [ "$just_characters" = true ]; then
        echo cleanOrigin "$origin"
        cleanOrigin "$origin"
        is_origin_clean=true
    fi
fi

if "$rsync_data"
then
    echo "starting rsync"
    count=0
    SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    #copy other origins to other_folder
    for other in ${!other_copying[@]}; do
        if [ ! -d "${other_copying[$other]}" ]; then
            if [ "$run_status" = 1 ]; then   
                mkdir -p "${other_copying[$other]}"       
            else
                echo mkdir -p "${other_copying[$other]}"       
            fi
        fi
        rot rsync $rsync_opt1 $rsync_opt2 "${other}" "${other_copying[$other]}"
    done

    if [ "$is_origin_clean" = false ] && [ "$doing_all" = true ]; then
        echo cleanOrigin "$origin"
        cleanOrigin "$origin"
        is_origin_clean=true
    fi

    for dest in ${dests[@]}; do 
        if [[ "$count" -eq 0 ]] 
        then
            #echo "origin:" $origin  
            #echo "dest:" $dest
            #echo rsync "$rsync_opt" "$backup_opt" "$origin" "$dest"
            rot rsync $rsync_opt1 $rsync_opt2 "$backup_script_opt" "$origin" "$dest"
        else
            #echo "origin:" $origin  
            #echo "dest:" $dest
            #echo bash backupscript.sh "$dest"
            rot bash backupscript.sh "$dest"
        fi
        ((count++))
    done
    IFS=$SAVEIFS
fi
