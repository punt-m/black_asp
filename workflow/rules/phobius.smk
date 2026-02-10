#This wrapper is needed to enable phobius to run the decodeanhmm script without other alterations to the phobius.pl script
#It basically ensures we can just download the program as is from source and use it without adjustments.
rule phobius:
    input:
        fasta = OUT + "/agat/proteins/{sample}.fa"
    output:
        results = OUT + "/phobius/{sample}.txt"
    params:
        phobius_dir = config['phobius']['dir'],
        workdir = temp(OUT + "/work/phobius/{sample}")
    log:
        OUT + "/log/phobius/{sample}.log"
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]
    threads: 1        
    shell:
        r"""
        mkdir -p {params.workdir}
        cp {params.phobius_dir}/phobius.pl {params.phobius_dir}/decodeanhmm.64bit \
           {params.phobius_dir}/phobius.options {params.phobius_dir}/phobius.model {params.workdir}
        cat << 'EOF' > {params.workdir}/decodeanhmm
#!/bin/bash
./decodeanhmm.64bit "$@"
EOF
chmod +x {params.workdir}/decodeanhmm
cd {params.workdir}
./phobius.pl -short {input.fasta} > {output.results} 2> {log}
        """

