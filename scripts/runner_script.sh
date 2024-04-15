#!/bin/bash

#runner script

# saftey first
set -euo pipefail

# create class proj
mkdir -p /fs/ess/PAS2700/users/$USER/class_project

# get in position
cd /fs/ess/PAS2700/users/$USER/class_project

# get data with get_data. This script will also make the dir if it does not already exist.
rawdir=./data/raw

sbatch ./scripts/get_data SRP083099 "$rawdir"

# check data with fastqc

## quality dir
mkdir -p ./quality/fastqc

## Load fastqc module
module load fastqc/0.11.8

## Set fastqc variables
qcoutdir=./quality/fastqc

for file in "$rawdir"/SRR*.fastq.gz; do
    fastqc -o "$qcoutdir" "$file"
done

# Set databases for kraken2 
## This uses a multithreaded SLURM job with 18 cpus, which is much faster
## This job requires an input for where the kraken2 database is to be stored. Here I will have 

K2DB=./kraken2/database

## If the dir does not yet exist, the script will make it!
## Additionally, if a conda enviroment does no exist, it will create one. The conda enviroment needs to explicitly be ./conda/kraken2
sbatch scripts/setup_kraken2_databases "$K2DB"

# run kraken2

## This script requires 2 inputs - the kraken2 database dir and the dir containing the .fastqc.gz data. 
## Here because all of the files were trimmed and had host reads removed and were of good quality from our earlier fastqc check, we use the "raw" data file
## Again, if a conda enviroment does no exist it will create one. The conda enviroment needs to explicitly be ./conda/kraken2

## the outputs of this script will be put in a dir called ./kraken2/kraken_reports for storing the reports and ./kraken2/kraken_outputs for storing the output files

K2DB=/fs/ess/PAS2700/users/awiedemer673/class_project/kraken2/database

sbatch ./scripts/run_kracken2.sh "$K2DB" "$rawdir"

