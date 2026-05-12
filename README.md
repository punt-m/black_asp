# Black aspergillus assembly pipeline
Based on the RIVM juno-pipeline

## Running the pipeline:
A typical submission command for the pipeline:
`python3 template.py -i ../irods_strains/250620_VH02218_26_AACV3HFHV_0003/ -o ../irods_strains/04Aug2025/ -ex subset_test.txt -c`
This requires access to the RIVM HPC. 

Alternatively, you can specify your own SnakeMake submission command based on the provided Snakefile and adding your own cluster specifications. As described, the snakemake rules should perform these actions: 

> Raw FASTQ files were trimmed and filtered with FastP (v0.20.1) using a Phred score of 28, a minimum read length of 50 and a window size of 5 as thresholds. The quality of the filtered reads was assessed using FastQC (v0.11.9). De novo assembly was conducted using SPAdes (v4.0.0) with the setting: --isolate. Scaffolds below 1000 bp were removed from the assembly and gene prediction was performed using Helixer (v0.3.3).EggNOG-mapper (v2.1.12) and InterProScan (v5.69-101.0) with Pfam 37.0, SUPERFAMILY 1.75 and TMHMM 2.0c enabled was used to predict protein function. Signal peptide for proteins were predicted with SignalP (6.0h). With the ‘annotate’ function from the funannotate suite (v1.8.17) the predicted protein functions were parsed, adding annotations for CAZYmes (dbCAN v13.0), and performing MEROPS (v12.0) and BUSCO 2.0 analysis.


## Contribution guidelines
Juno pipelines use a [feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). To work on features, create a branch from the `main` branch to make changes to. This branch can be merged to the main branch via a pull request. Hotfixes for bugs can be committed to the `main` branch.



