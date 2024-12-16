rule spades:
    input:
        R1 = OUT + "/clean_fastq/{sample}_pR1.fastq.gz",
        R2 = OUT + "/clean_fastq/{sample}_pR2.fastq.gz",
    output:
        directory(OUT + '/spades/{sample}')
    threads:
        config["threads"]["spades"]
    resources:
        mem_gb = config["mem_gb"]["spades"],
        runtime_min = config["runtime_min"]["spades"],
        queue = config['queue']["default"]
    log:
        OUT + "/log/spades/{sample}.log"
    shell:
        '/mnt/scratch_dir/puntm/local_software/SPAdes-4.0.0-Linux/bin/spades.py --pe1-1 {input.R1} --pe1-2 {input.R2} -o {output} > {log} 2>&1'