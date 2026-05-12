# Black aspergillus assembly pipeline
Based on the RIVM juno-pipeline

## Running the pipeline:
A typical submission command for the pipeline:
`python3 template.py -i ../irods_strains/250620_VH02218_26_AACV3HFHV_0003/ -o ../irods_strains/04Aug2025/ -ex subset_test.txt -c`
This requires access to the RIVM HPC. 

Alternatively, you can specify your own SnakeMake submission command based on the provided Snakefile and adding your own cluster specifications. As described, the snakemake rules should perform these actions: 

MarkDuplicates (from Picard v5.8.2) is used to mark PCR duplicates. Variant calling was performed using the GATK Toolkit (v4.6.1.0) following the best practices described. In short, a first pass of HaplotypeCaller identified SNVs per isolate, then the BAM files were recalibrated using BaseRecalibrator and ApplyBQSR before running a second pass of HaplotypeCaller to generate single-sample GVCFs. The GVCFs were stored in a GenomicsDB and single-nucleotide polymorphisms (SNPs) and insertions/deletions (INDELs) were selected with SelectVariants, VariantFilteration was used to select high quality variants using MQ < 40 || QD < 2.0 || FS > 60.0. The variants passing the filters were used as input for downstream analysis.


## Contribution guidelines
Juno pipelines use a [feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). To work on features, create a branch from the `main` branch to make changes to. This branch can be merged to the main branch via a pull request. Hotfixes for bugs can be committed to the `main` branch.



