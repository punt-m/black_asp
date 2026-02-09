rule phobius:
    input:
        fasta = OUT + "/agat/proteins/{sample}.fa"
    output:
        results = OUT + "/phobius/{sample}.txt"
    params: 
        exec = config['phobius']['exec'],
    log:
        OUT + "/log/phobius/{sample}.log"
    threads: 1
    shell:
        """
        # Zorg dat het pad naar phobius in je PATH staat of gebruik het volledige pad
        {params.exec} -short {input.fasta} > {output.results} 2> {log}
        """