# Runs IPS, installing the needed dependecies and licensd software of this tool takes some time
# we could consider using the tool w/o all the accepted annotation tools it now takes to reduce build time
rule interproscan:
    input:
        OUT + "/agat/proteins/{sample}.fa"
    output:
        xml = OUT + "/interproscan/{sample}.xml"
    params:
        tempdir = OUT + '/IPS_temp/{sample}',
    log:
        OUT + "/log/interproscan/{sample}.log"
    ##conda:
    ##    "../envs/java11.yml"
    container:
        "/mnt/scratch_dir/puntm/local_software/interproscan/singularity/IPS_check"
        #docker://interpro/interproscan:5.77-108.0
    resources:
        mem_gb = config["mem_gb"]["interproscan"],
        runtime_min = config["runtime_min"]["interproscan"],
        queue = config['queue']["default"]
    threads:
        config["threads"]["interproscan"]-2
    shell:
        """
        mkdir -p {params.tempdir};
        /opt/interproscan/interproscan.sh \
                                         --input {input} \
                                         --disable-precalc \
                                         --goterms \
                                         -dra \
                                         -appl Pfam \
                                         -o {output.xml} \
                                         -f XML \
                                         --tempdir {params.tempdir} \
                                         --cpu {threads} \
                                         >& {log} \
                                         """
        #                                 --applications Gene3D-4.3.0 \
