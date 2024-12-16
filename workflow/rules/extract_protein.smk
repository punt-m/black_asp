
#This rule gets the protein sequences from the gff/fasta combination. 
#The protein codon table can be adjusted, now its using default but might need some change for fungi
rule agat:
    input: 
        gff3 = OUT + "/helixer/gff/{sample}.gff3",
        fasta =  OUT + "/sorted/{sample}.short.fa"
    output: 
        OUT + "/agat/proteins/{sample}.fa"
    log:
        OUT + "/log/agat/{sample}.log"
    resources:
        mem_gb = config["mem_gb"]["default"],
        runtime_min = config["runtime_min"]["default"],
        queue = config['queue']["default"]

    conda:
        '../envs/agat.yml'
   
    shell:
        """
        agat_sp_extract_sequences.pl --gff {input.gff3} -f {input.fasta} --cfs -p -o {output} >& {log}
        """