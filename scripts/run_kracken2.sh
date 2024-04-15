#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 4:00:00
#SBATCH --cpus-per-task=18
#SBATCH --mail-type=END,FAIL

set -euo pipefail

# get in the right place
cd /fs/ess/PAS2700/users/$USER/class_project/

# input vaiables
DBNAME=$1
INPUTDATA=$2

#check if input is correct
if [[ ! "$#" -eq 2 ]]; then
    echo "Error: Requires kraken2 database dir and input data dir containing .fastq.gz files"
    exit 1
fi

# output variables - automatically creates

REPORTDIR=./kraken2/kraken_reports

OUTDIR=./kraken2/kraken_outputs

# make dirs
mkdir -p $REPORTDIR $OUTDIR

# Initial reporting
echo "# Starting script run_kraken2.sh"
date
echo "# kraken2 database dir:          $DBNAME"
echo "# input data dir:                $INPUTDATA"
echo "# report output dir:             $REPORTDIR"
echo "# results output dir:            $OUTDIR"

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


# run kraken2

for file in "$INPUTDATA"/*.fastq.gz; do

    # set location
    REPORTOUT="$REPORTDIR"/"$(basename "$file" .fastq.gz)".k2report
    OUTPUT="$OUTDIR"/"$(basename "$file" .fastq.gz)".kraken2

    # report
    echo "Input file: $file"
    echo "Report file: $REPORTOUT" 
    echo "Output file: $OUTPUT"

    # run kraken2

   kraken2 --db $DBNAME --gzip-compressed --report $REPORTOUT --report-minimizer-data --minimum-hit-groups 3 --threads 18 $file > $OUTPUT
done

# Final reporting
echo 
echo "# Finished script run_kraken2.sh"
date