#!/bin/bash
#SBATCH --account=PAS2700
#SBATCH --time 4:00:00
#SBATCH --cpus-per-task=20
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


# output dirs from run_kraken2
K2REP_DIR=./kraken2/kraken_reports

K2_OUTPUT=./kraken2/kraken_outputs

# kraken2 location

K2LOCATION=./conda/kraken2

# species level assignment
LEVEL="S"

# threshold level of 10 reads in accordance with https://doi.org/10.1038/s41596-022-00738-y
THRESH=10

# output variables - automatically creates
OUTDIR=./bracken/bracken_outputs

REP_OUTDIR=./bracken/bracken_reports

# make dirs
mkdir -p $OUTDIR $REP_OUTDIR

# Initial reporting
echo "# Starting script run_bracken.sh"
date
echo "# kraken2 database dir:          $KRAKEN_DB"
echo "# k-mers:                        $KMERS"
echo "# read length:                   $READ_LENGTH"
echo
echo "# kraken2 location:              $K2LOCATION"
echo
echo "# kraken2 results dir:           $K2_OUTPUT"
echo "# kraken2 reports dir:           $K2REP_DIR"
echo "# taxa level:                    $LEVEL"
echo "# number of reads before"
echo "# abundance estimation" 
echo "# to perform re-estimation:      $THRESH"
echo
echo "# output results dir:            $OUTDIR"
echo "# output report dir:             $REP_OUTDIR"

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
bracken-build -v -d "$KRAKEN_DB" -t 20 -k $KMERS -l $READ_LENGTH -x $K2LOCATION

# run bracken
## Here I tried to be clever and use the input names from the kraken2 output
for file in "$K2_OUTPUT"/*.kraken2; do

    # set inputs and outputs
    K2REP_INPUT="$K2REP_DIR"/"$(basename "$file" .kraken2)".k2report 
    K2_INPUT="$K2_OUTPUT"/"$(basename "$file" .kraken2)".kraken2
    OUTPUT="$OUTDIR"/"$(basename "$file" .kraken2)".bracken

    # report
    echo "# Input file name:    $(basename $file .kraken2) "
    echo "# kraken2 report file: $K2REP_INPUT"
    echo "# kraken2 file:        $K2_INPUT" 
    echo "# Output file:         $OUTPUT"

    # run bracken
    bracken -d "$KRAKEN_DB" -i "$K2REP_INPUT" -o "$OUTPUT" -r "$READ_LENGTH" -l "$LEVEL" -t "$THRESH" -w $REP_OUTDIR

done

# Final reporting
echo 
echo "# Finished script run_bracken.sh"
date
