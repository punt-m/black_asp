rule fasta_format:
    input:
        OUT + '/spades/{sample}'
    output:
        OUT + "/fasta_format/{sample}.fa"
    params:
        blocksize = config['fastx-toolkit']['blocksize']
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]
    log:
        OUT + "/log/fasta_format/{sample}.log"
    conda:
        'workflow/envs/fastx-toolkit.yml'
    shell:
        'fasta_formatter -i {input}/assembly.fasta -w {params.blocksize} > {output}'


#Rule generates gff3 files using deeplearning and GPU resources, is very quick and does not really
# underperform when compared with BRAKER2.
rule helixer:
    input: 
        rules.fasta_format.output
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



#This rule gets the protein sequences from the gff/fasta combination. 
#The protein codon table can be adjusted, now its using default but might need some change for fungi
rule agat:
    input: 
        gff3 = rules.helixer.output,
        fasta = rules.fasta_format.output
    output: 
        OUT + "/agat/proteins/{sample}.fa"
    log:
        OUT + "/log/agat/{sample}.log"
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]

    conda:
        'workflow/envs/agat.yml'
   
    shell:
        """
        mkdir -p agat/proteins/;
        agat_sp_extract_sequences.pl --gff {input.gff3} -f {input.fasta} --cfs -p -o {output} >& {log}
        """

#Runs IPS, installing the needed dependecies and licensd software of this tool takes some time
# we could consider using the tool w/o all the accepted annotation tools it now takes to reduce build time
rule interproscan:
    input:
        rules.agat.output
    output:
        xml = directory(OUT + "/interproscan/{sample}")
    params:
        tempdir = OUT + '/temp/{sample}',
        ips_exc = config['interproscan']['exec']
    log:
        OUT + "/log/interproscan/{sample}.log"
    conda:
        "workflow/envs/java11.yml"

    resources:
        mem_gb = config["mem_gb"]["interproscan"],
        runtime_min = config["runtime_min"]["interproscan"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["interproscan"]
    shell:
        """
        mkdir -p {params.tempdir};
        mkdir -p {output.xml};
        {params.ips_exc} --input {input} \
                                          --disable-precalc \
                                          --goterms \
                                          --excl-applications SignalP_GRAM_NEGATIVE-4.1,SignalP_GRAM_POSITIVE-4.1 \
                                          --output-dir {output.xml} \
                                          --tempdir {params.tempdir} \
                                          --cpu {threads} \
                                          >& {log} \
                                          """
                                          #--applications Gene3D-4.3.0 \

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
        "workflow/envs/eggnog.yml"
    resources:
        mem_gb = config["mem_gb"]["eggnog"],
        runtime_min = config["runtime_min"]["eggnog"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["eggnog"]
    shell:
        """
        mkdir -p log/emapper/; 
        mkdir -p {output};
        mkdir -p {params.tempdir};
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
        'workflow/envs/signalp6.yml'
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

# Make sure databases re installed and directed towards in ENV. 
##  funannotate setup -d env_db/funannotate_db;
##  export FUNANNOTATE_DB=env_db/funannotate_db

rule fun_annotate:
    input:
        fasta  = rules.fasta_format.output,
        gff    = rules.helixer.output,
        ips    = rules.interproscan.output,
        signalp= rules.signalp.output,
        eggnog = rules.emapper.output
    output:
        directory(OUT + "/fun_annotate/{sample}")
    log:
        OUT + "/log/fun_annotate/{sample}.log"
    conda: 
        'workflow/envs/funannotate.yml'
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
        mkdir -p {output} ;
        export FUNANNOTATE_DB={params.fun_db} ;
        funannotate annotate --gff {input.gff} \
                                --fasta {input.fasta} \
                                --eggnog {input.eggnog}/{params.strain}.emapper.annotations \
                                --species '{params.species}' \
                                --iprscan {input.ips}/{params.strain}.fa.xml \
                                --signalp {input.signalp}/prediction_results.txt \
                                --strain {params.strain} \
                                --out {output} \
                                --cpus {threads} \
                                >& {log}\

                               """