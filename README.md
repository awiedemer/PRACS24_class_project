# Overview

This repo contains code and communications related to a **class project** for **PLNTPTH 6193 - Practical Computing for biologists**

# Summary

A study by [De Angelis et al.](https://www.nature.com/articles/s41598-020-61192-y#data-availability) found associations between the human gut microbiome and diet. In it they took shotgun metagenomic samples of the human gut microbiome from 30 volunteers on either a omnivourus, vegan, or vegetarian diet and correlated diet with gut microbial profile. 

The human gut microbiome shotgun metagenomic data with sequences filtered for human reads and trimmed of low-quality bases are publically available through the National Center for Biotechnology Information Sequence Read Archive (NCBI SRA; SRP083099, Bioproject ID PRJNA340216).

In my project I intend to 

1. Download human gut microbiome shotgun metagenomic dataset files from NCBI SRA; SRP083099, Bioproject ID PRJNA340216
2. Check quality 
3. Run Kraken2 for assigning taxonomy
4. Run Bracken to estimate species-level relative abundances 

# How use this project

The workflow for this analysis is all self contained in the __runner_script.sh__, which itself relies on multiple SLURM batch job scripts located in the __scripts__ directory

Overall, the workflow is
1. Download metagenomics data
2. Check data quality with `fastqc`
3. Set up `Kraken2` (needs databases)
4. Set up `Bracken`
5. Run `Kraken2`
6. Run `Bracken`

Following the runner script is simple, but time consuming as each batch job can take several hours to days (downloading metagenomics data takes quite some time)

All directories, conda enviroments, and outputs are autopopulated by running the script making this code easy to run and reporducable 

## What can this script be used on?

This script is customized for this specific data analysis - this code could be used to check other NCBI metagenomic datasets, but could not be run as is for say your own custom data

## What if I wanted to customize it to analyze my own data?

What this script is __missing__ is quality improvement and host read removal which would be done with something like __trimmomatic__ and __BowTie2__ respectivly - since the NCBI data has already had these steps completed, they were not included in this workflow. 


## Submission Notes
Most of this code works for me, but I have had particular trouble getting the `get_data.sh` script to download all the files and it __may only partially download the requested data__ (as in not all of the requested files, the files that are available are complete though). I have used what data did download for this project, and have not tried to rerun it due to the large time requirments. These scripts were able to run on the data available and should still work with new files though.

Additionally, the file paths for all of the scripts require the user to have acess to the `/fs/ess/PAS2700/users/$USER` directory. All of the scripts currently require that this path be available, and other users will need to tweak the scripts to be able to use another directory, available at the top of each script. 