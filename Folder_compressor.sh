#!/bin/bash 
#SBATCH --time=96:00:00
#SBATCH --ntasks=8
#SBATCH --mem=10g
#SBATCH --tmp=10g
#SBATCH --mail-type=ALL  
#SBATCH --mail-user=rakakpo@umn.edu 


#   Requires one argument: the path to the folder to be compressed

if [ "$1" == "-h" ]; then
#   Helper
  echo " "
  echo "###############################"
  echo "#### The command line help ####"
  echo "###############################"
  
  echo " "
  
  echo "description: compress a whole folder"
  
  echo " "
  
  echo "arg1 = Full path to folder to be compressed"
  
  echo " "
  
  echo "compressed folder name =   foldername_date"
  
  echo " "
  
  echo "#### rakakpo@umn.edu ####"
   
  echo " "
  
  exit 1
  
fi

# Script

if [[ -z "$1" ]]; then 
  echo "Warning Argument is missing" 
  exit 0 
fi

if 

[[ -f "$1" || -d "$1" ]]; then  
  
  echo " "
  
  echo "Processing:"
  
  echo " "
  
  tar -zcvf $1"_"$(date '+%d-%m-%y').tar.gz $1
fi
