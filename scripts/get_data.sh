#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/$USER/class_project/

# set variable for SRA files to download. This script only will take NCBI SRA names
SRA_name=$1

# dir variable
outdir=$2

# Initial reporting
echo "# Starting script get_data.sh"
date
echo "# Input SRA file:      $SRA_name"
echo "# Output dir:          $outdir"
echo

#check if input is correct
if [[ ! "$#" -eq 2 ]]; then
    echo "Error: Requires 2 inputs of database name followed by output dir"
    exit 1
fi

# load conda
module load miniconda3/24.1.2-py310

# Check if the ./conda/fastq-dl directory exists
if [ ! -d "./conda/fastq-dl" ]; then
    echo "Directory ./conda/fastq-dl does not exist. Creating conda environment."
    conda create -y -c conda-forge -c bioconda -p ./conda/fastq-dl fastq-dl
    echo "Completed creating conda environment."
else
    echo "./conda/fastq-dl already exists."
fi

# Check if the output dir directory exists
if [ ! -d "$outdir" ]; then
    echo "Directory $outdir does not exist. Creating directory."
    mkdir -p $outdir
    echo "Completed creating $outdir directory."
else
    echo "$outdir already exists."
fi

# activate fastq-dl for downloading data
conda activate ./conda/fastq-dl

# get da data
fastq-dl --accession "$SRA_name" --provider sra --outdir "$outdir" --only-provider  

# Final reporting
echo 
echo "# Finished script get_data.sh"
date