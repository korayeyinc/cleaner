#!/usr/bin/env bash
# A simple Bash script for removing redundant/duplicate backup files
# in specified directories and generating a cleanup report & log.

# set filepath globbing options
shopt -s globstar nullglob

# set the filenames
filelist=files.txt
rootdirectories=directories.txt
logfile=$(date +"%d-%m-%Y_%T").log

#create logfile first
touch "$PWD/$logfile"

# read filenames recursively from $filelist
while read filename
do
    fn=0
    dn=0
    # read dirnames recursively from $rootdirectories
    while read dirname
    do
        # recursively scan all the matching filepaths in subdirectories
        filepaths=( "$dirname/**/$filename" )
        
        for fpath in $filepaths
        do
            [ -e $fpath ] || continue
            rm "$fpath"
            echo "[INFO]    Removed $fpath" | tee -a $logfile
            ((fn++))
            ((dn++))
        done
    done < $rootdirectories
    [ $fn -gt "0" ] || continue
    # write the report line to $logfile
    echo "[Summary] The '$filename' file appeared $fn times in $dn directories and all were deleted successfully!" | tee -a $logfile
    echo | tee -a $logfile
done < $filelist
