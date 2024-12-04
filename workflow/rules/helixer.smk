#Rule generates gff3 files using deeplearning and GPU resources, is very quick and does not really
# underperform when compared with BRAKER2.
rule helixer:
    input: 
        rules.fun_annotate_sort.output
    output: 
        OUT + "/helixer/gff/{sample}.gff3"
    log:
        OUT + "/log/helixer/{sample}.log"
    resources:
        gpu = 1,
        mem_gb = config["mem_gb"]["helixer"],
        runtime_min = config["runtime_min"]["helixer"],
        queue = config['queue']['helixer']
    
    container: 
        'docker://gglyptodon/helixer-docker:helixer_v0.3.3_cuda_11.8.0-cudnn8'
    #container:
    #    'env_db/helixer-docker_helixer_v0.3.3_cuda_11.8.0-cudnn8.sif'
   
    shell:
        """
        Helixer.py\
        --model-filepath config/fungi_db/fungi_v0.3_a_0400.h5 \
        --species Aspergillus_niger \
        --subsequence-length 21384 \
        --fasta-path {input} \
        --gff-output-path {output} \
        >& {log}"""


