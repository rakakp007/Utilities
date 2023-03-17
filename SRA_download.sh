#!/bin/env sh


#Read the file containning SRA ID
SRA_FILES=SRA_Acc_List.txt

#   Make sure the file exists
if ! [[ -f "${SRA_FILES}" ]]
    then echo "Failed to find ${SRA_FILES}, exiting..." >&2
    exit 1
    fi 

#   Make the array using command substitution
declare -a SRA_ARRAY=($(cat "${SRA_FILES}")) 

#   Print the values of the array to screen
printf '%s\n' "${SRA_ARRAY[@]}"

#   location of SRA download script, from Tom Kono's Misc_Utils
SRA_FETCH=$SRA_Fetch.sh 

#   directory where SRA files will be downloaded
OUTPUT=$/Users/rakakpo/MorrellLab Dropbox/Roland Akakpo/IITA_CORE_DATA/cowpea_gwas-main/LD_Analysis/Fastq_data/

#   iterate over every each of the run numbers in a lit of SRA files
#   and download to specified directory
#   in SRA_Fetch -r = run #, -e experiment #, -p sample #, -s study #
for i in "${SRA_ARRAY[@]}"
    do bash $SRA_FETCH -r $i -d $OUTPUT
    done
