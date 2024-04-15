#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 12:00:00
#SBATCH --cpus-per-task=28
#SBATCH --mail-type=END,FAIL

#saftey first
set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/$USER/class_project/

# variables
DBNAME=$1

#check if input is correct
if [[ ! "$#" -eq 1 ]]; then
    echo "Error: Requires database output dir"
    exit 1
fi

# Initial reporting
echo "# Starting script setup_kraken2_databases"
date
echo "# Output kraken2 database dir:          $DBNAME"
echo

# load conda
module load miniconda3/24.1.2-py310

# Check if the kraken2 is in the conda dir
if [ ! -d "./conda/kraken2" ]; then
    echo "Directory ./conda/kraken2 does not exist. Creating conda environment."
    conda create -y -p ./conda/kraken2 -c bioconda kraken2
else
    echo "./conda/kraken2 already exists."
fi

# activate kraken2
conda activate ./conda/kraken2

# Check if the database file exists, and create if not
if [ ! -f "$DBNAME" ]; then
    echo "Database file $DBNAME does not exist. Creating directory and building database."
    mkdir -p "$DBNAME"
    kraken2-build --standard --db "$DBNAME"
elif [ ! -s "$DBNAME" ]; then
    echo "Database file $DBNAME is empty. Building database."
    kraken2-build --standard --threads 28 --db "$DBNAME"
else
    echo "Kraken2 database is already built"
fi

# Final reporting
echo 
echo "# Finished script setup_kraken2_databases"
date