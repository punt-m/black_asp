# Make sure databases re installed and directed towards in ENV. 
##  funannotate setup -d env_db/funannotate_db;
##  export FUNANNOTATE_DB=env_db/funannotate_db

rule fun_annotate:
    input:
        fasta  = OUT + "/sorted/{sample}.short.fa",
        gff    = OUT + "/helixer/gff/{sample}.gff3",
        ips    = OUT + "/interproscan/{sample}.xml",
        signalp= OUT + '/signalp/{sample}',
        eggnog = OUT + "/emapper/{sample}"
    output:
        directory(OUT + "/fun_annotate/{sample}")
    log:
        OUT + "/log/fun_annotate/{sample}.log"
    conda: 
        '../envs/funannotate.yml'
    params: 
        species = config['fun_annotate']['species'],
        fun_db = config['fun_annotate']['database'],
        strain = '{sample}'
    resources:
        mem_gb = config["mem_gb"]["fun_annotate"],
        runtime_min = config["runtime_min"]["fun_annotate"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["fun_annotate"]
    shell:
        """
        export FUNANNOTATE_DB={params.fun_db} ;
        funannotate annotate --gff {input.gff} \
                                --fasta {input.fasta} \
                                --eggnog {input.eggnog}/{params.strain}.emapper.annotations \
                                --species "{params.species}"\
                                --iprscan {input.ips} \
                                --signalp {input.signalp}/prediction_results.txt \
                                --strain {params.strain} \
                                --force \
                                --out {output} \
                                --cpus {threads} \
                                >& {log}\
                               """