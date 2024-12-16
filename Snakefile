import yaml

sample_sheet=config["sample_sheet"]
with open(sample_sheet) as f:
    SAMPLES = yaml.safe_load(f)

for param in ["threads", "mem_gb",'runtime_min']:
    for k in config[param]:
        config[param][k] = int(config[param][k])

#print(config)

OUT = config["output_dir"]

localrules:
    all,
include: "workflow/rules/clean_fastq.smk"
include: "workflow/rules/spades.smk"
include: "workflow/rules/reformat_fasta.smk"
include: "workflow/rules/helixer.smk"
include: "workflow/rules/extract_protein.smk"
include: "workflow/rules/interproscan.smk"
include: "workflow/rules/signalp.smk"
include: "workflow/rules/emapper.smk"
include: "workflow/rules/funannotate.smk"
#include: "workflow/rules/interproscan_standalone.smk"

rule all:
    input:
        #expand(OUT + "/interproscan/test/"),
        #expand(OUT + '/spades/{sample}', sample = SAMPLES),
        expand(OUT + "/fun_annotate/{sample}", sample = SAMPLES),
        #expand(OUT + "/interproscan/{sample}.xml", sample = SAMPLES),