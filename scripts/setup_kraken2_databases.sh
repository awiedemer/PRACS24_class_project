#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 4:00:00
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=END,FAIL

#saftey first
set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/awiedemer673/class_project/

# load conda
module load miniconda3/24.1.2-py310

# Check if the ./conda/kraken2 directory exists
if [ ! -d "./conda/kraken2" ]; then
    echo "Directory ./conda/kraken2 does not exist. Creating conda environment."
    conda create -y -p ./conda/kraken2 -c bioconda kraken2
else
    echo "./conda/kraken2 already exists."
fi

# activate kraken2
conda activate ./conda/kraken2

# variables
DBNAME=./kraken2/database

# Check if the database file exists, and create if not
if [ ! -f "$DBNAME" ]; then
    echo "Database file $DBNAME does not exist. Creating directory and building database."
    mkdir -p "$DBNAME"
    kraken2-build --standard --db "$DBNAME"
elif [ ! -s "$DBNAME" ]; then
    echo "Database file $DBNAME is empty. Building database."
    kraken2-build --standard --db "$DBNAME"
else
    echo "Kraken2 database is already built"
fi

# set up kraken2 databases
kraken2-build --standard --threads 10 --db $DBNAME