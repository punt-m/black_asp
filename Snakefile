import yaml


sample_sheet=config["sample_sheet"]
with open(sample_sheet) as f:
    SAMPLES = yaml.safe_load(f)

for param in ["threads", "mem_gb"]:
    for k in config[param]:
        config[param][k] = int(config[param][k])

print(config)

OUT = config["output_dir"]

localrules:
    all,
include: "workflow/rules/clean_fastq.smk"
include: "workflow/rules/spades.smk"
include: "workflow/rules/helixer.smk"

rule all:
    input:
        expand(OUT + "/fun_annotate/{sample}", sample = SAMPLES),
        expand(OUT + '/spades/{sample}', sample = SAMPLES),
