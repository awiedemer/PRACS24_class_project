#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/awiedemer673/class_project/

# set variable for SRA files to download. This script only will take NCBI SRA names
SRA_name=$1

# load conda
module load miniconda3/24.1.2-py310

# Check if the ./conda/fastq-dl directory exists
if [ ! -d "./conda/fastq-dl" ]; then
    echo "Directory ./conda/fastq-dl does not exist. Creating conda environment."
    conda create -y -c conda-forge -c bioconda -p ./conda/fastq-dl fastq-dl
else
    echo "./conda/fastq-dl already exists."
fi

# Check if the ./data/fastqc directory exists
if [ ! -d "./data/fastqc" ]; then
    echo "Directory ./data/fastqc does not exist. Creating directory."
    mkdir -p ./data/fastqc
else
    echo "./data/fastqc already exists."
fi

# activate fastq-dl for downloading data
conda activate ./conda/fastq-dl

# get da data
fastq-dl --accession "$SRA_name" --provider sra --outdir ./data/fastqc --only-provider  