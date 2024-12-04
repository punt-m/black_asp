rule signalp:
    input:
        rules.agat.output
    output:
        directory(OUT + '/signalp/{sample}')
    params:
        models =  config["signalp"]["models"],
        signalp_dir = config["signalp"]["directory"],
        signalp_env    = config['signalp']['env']
    log: OUT + '/log/signalp/{sample}.log'
    conda: 
        '../envs/signalp6.yml'
    resources:
        mem_gb = config["mem_gb"]["signalp"],
        runtime_min = config["runtime_min"]["signalp"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["signalp"]
    shell:
        """
        export PYTHONPATH={params.signalp_env};
        {params.signalp_dir} \
            --output_dir {output} \
            --model_dir {params.models} \
            -org euk --mode fast -format none \
            -fasta {input}\
            --write_procs {threads} &> {log}"""
