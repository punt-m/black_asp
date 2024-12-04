#Eggnog 
rule emapper:
    input:
        rules.agat.output
    output:
        directory(OUT + "/emapper/{sample}")
    params:
        tempdir = OUT + '/temp/{sample}',
        data_dir = config['eggnog']['data_dir'],
        dia_db = config['eggnog']['dia_db']
    log:
        OUT + "/log/emapper/{sample}.log"
    conda:
        "../envs/eggnog.yml"
    resources:
        mem_gb = config["mem_gb"]["eggnog"],
        runtime_min = config["runtime_min"]["eggnog"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["eggnog"]
    shell:
        """
        mkdir -p {params.tempdir};
        mkdir -p {output};
        emapper.py -i {input} \
         --output_dir {output} \
         --output {wildcards.sample} \
         --dmnd_db {params.dia_db}\
        -d euk \
        -m diamond \
        --dbmem \
        --temp_dir {params.tempdir} \
        --data_dir {params.data_dir} \
        --cpu {threads} \
        --override \
        >& {log}\
                                          """