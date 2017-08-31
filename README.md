This bash script backs up folders to multiple directories using rysnc. It also has a menu option that gets rid of characters in paths that cause problems with rsync.

# Copying multiple directories
in vars.sh you will see the default "other\_copying" associative array, this copies 
/data/backup/backup\_src/other\_origin 

to 

${origin}${other\_folder}another\_folder/"

other\_copying array here:
```
declare -A other_copying=( ["/data/backup/backup_src/other_origin/"]="${origin}${other_folder}another_folder/" )
``` 
You can add folders to this array, for example, this example--will in addition--copy:

/data/backup/backup\_src/other\_origin/

to:

${origin}${other\_folder}home\_folder/

other\_copying folder:
```
declare -A other_copying=( ["/data/backup/backup_src/other_origin/"]="${origin}${other_folder}another_folder/"  ["/home/joel"]="${origin}${other_folder}home_folder/")

```

# Test Mode
Edit the directories in vars.sh and test with:
```
sudo ./backup.sh
```
This will show you the commands it would run if it were in run mode in addition to various other outputs I think are helpful. Outputs of commands are marked starting with the text "command=" with the actual command in quotations:
```
command="[actual command]"
```
output of commands starts with the label "output="
```
output="[actual output]"
```

# Run Mode
To put it in run mode, run with:
```
sudo ./backup.sh run
```
It will show you the commands it is running and the output of those commands similar to test mode.

In both running and testing it will display the source and destinations and ask you to confirm if you want to continue.


