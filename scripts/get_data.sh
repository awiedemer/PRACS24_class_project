#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# load conda
module load miniconda3/24.1.2-py310

# activate fastq-dl for downloading data
conda activate /fs/ess/PAS2700/users/awiedemer673/class_project/conda/fastq-dl

# get da data
fastq-dl --accession SRP083099 --provider sra --outdir /fs/ess/PAS2700/users/awiedemer673/class_project/data/fastqc --only-provider  