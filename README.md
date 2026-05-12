# Black aspergillus assembly pipeline
Based on the RIVM juno-pipeline

## Running the pipeline:
A typical submission command for the pipeline:
`python3 template.py -i ../irods_strains/250620_VH02218_26_AACV3HFHV_0003/ -o ../irods_strains/04Aug2025/ -ex subset_test.txt -c`
This requires access to the RIVM HPC. 

Alternatively, you can specify your own SnakeMake submission command based on the provided Snakefile and adding your own cluster specifications. 


## Contribution guidelines
Juno pipelines use a [feature branch workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/feature-branch-workflow). To work on features, create a branch from the `main` branch to make changes to. This branch can be merged to the main branch via a pull request. Hotfixes for bugs can be committed to the `main` branch.



