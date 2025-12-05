rule spades:
    input:
        R1 = rules.clean_fastq.output.r1,
        R2 = rules.clean_fastq.output.r2,
        unpaired = rules.clean_fastq.output.unpaired,
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
        r"""
        # check if unpaired exists and is >1MB
        extra=""
        if [ -s {input.unpaired} ] && [ $(stat -c%s {input.unpaired}) -gt 1000000 ]; then
            extra="--pe1-s {input.unpaired}"
        fi

        /mnt/scratch_dir/puntm/local_software/SPAdes-4.0.0-Linux/bin/spades.py \
            --pe1-1 {input.R1} \
            --pe1-2 {input.R2} \
            $extra \
            --isolate -o {output} > {log} 2>&1
        """