rule fasta_format:
    input:
        OUT + '/spades/{sample}'
    output:
        OUT + "/fasta_format/{sample}.fa"
    params:
        blocksize = config['fastx_toolkit']['blocksize']
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]
    log:
        OUT + "/log/fasta_format/{sample}.log"
    conda:
        '../envs/fastx_toolkit.yml'
    shell:
        'fasta_formatter -i {input}/scaffolds.fasta -w {params.blocksize} > {output}'

rule fun_annotate_sort:
    input:
        fasta  = rules.fasta_format.output
    output:
        OUT + "/sorted/{sample}.short.fa"
    log:
        OUT + "/log/fun_annotate/{sample}_sort.log"
    conda: 
        '../envs/funannotate.yml'
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["default"]
    shell:
        """
        funannotate sort -i {input.fasta} \
                                  -o {output} \
                                  --minlen 1 \
                                  >& {log} \
                               """
