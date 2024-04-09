
Aaron Wiedemer
PLNTPTH 6193 
Project Proposal

# Overview

A study by [De Angelis et al.][https://www.nature.com/articles/s41598-020-61192-y#data-availability] found associations between the human gut microbiome and diet. In it they took shotgun metagenomic samples of the human gut microbiome from 30 volunteers on either a omnivourus, vegan, or vegetarian diet and correlated diet with gut microbial profile. 

The human gut microbiome shotgun metagenomic data with sequences filtered for human reads and trimmed of low-quality bases are publically available through the National Center for Biotechnology Information Sequence Read Archive (NCBI SRA; SRP083099, Bioproject ID PRJNA340216).

In my project I intend to 

1. Download human gut microbiome shotgun metagenomic dataset files from NCBI SRA; SRP083099, Bioproject ID PRJNA340216
2. Check quality 
3. Run Kraken2 for assigning taxonomy
4. Run Bracken to estimate species-level relative abundances 

## Why this?

Pending on a grant, I will be working with human gut microbiome shotgun metagenomic data following a clinical dietary intervention study. This study was cited in the grant proposal and has similar data to what I will be working with. Doing this will give me a little more experience to tackle this project.

# Technical aspects

I hope to make three data piplines using shell scripts in the OSC to

1. Automatically download the data from NCBI with either SFTP or Globus (I am currently unsure on how to do this)
2. Check data quality (either fastQC or multiQC, SLURM batch job)
3. Assign taxonomy with Karken2 (this will most defenetly be a SLURM batch job)
4. Estimate species-level relative abundances with Bracken (this will most defenetly be a SLURM batch job)

# Uncertenties

Most of these tools are new to me and I will have to learn them, so I am mostly uncertain about having to learn those. 

- I do not know how to get the data from NCBI using SFTP or Globus
- I do not know how to use Kraken2 nor Bracken and will have to learn it

For this analysis, I'm also uncertain if using this k-mers approach is better than building contigs and I will look into the pros and cons of using each

