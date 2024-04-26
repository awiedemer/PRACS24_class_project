#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 4:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/$USER/class_project/

# variables
KRAKEN_DB=$1
KMERS=$2
READ_LENGTH=$3

#check if input is correct
if [[ ! "$#" -eq 3 ]]; then
    echo "Error: Requires kraken2 database dir, kmer length used (35 if using kraken2), read length)"
    exit 1
fi

# kraken2 location
K2LOCATION=./conda/kraken2/

# Initial reporting
echo "# Starting script run_bracken.sh"
date
echo "# kraken2 database dir:          $KRAKEN_DB"
echo "# k-mers:                        $KMERS"
echo "# read length:                   $READ_LENGTH"
echo
echo "# kraken2 location:              $K2LOCATION"

# load conda
module load miniconda3/24.1.2-py310

# Check if the ./conda/bracken directory exists
if [ ! -d "./conda/bracken" ]; then
    echo "Directory ./conda/bracken does not exist. Creating conda environment."
    conda create -y -p ./conda/bracken -c bioconda bracken
    echo "Completed creating Bracken conda environment."
else
    echo "./conda/bracken already exists."
fi

# activate bracken
conda activate ./conda/bracken

# build bracken
bracken-build -d "$KRAKEN_DB" -t 30 -k "$KMERS" -l "$READ_LENGTH"

# Final reporting
echo 
echo "# Finished script setup_bracken.sh"
date