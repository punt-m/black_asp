singularity exec --bind /mnt/scratch_dir/puntm:/mnt/scratch_dir/puntm/ \
            .snakemake/singularity/6c0748e7b65514d9ca7fdd9c1baeae12.simg \
            fastp \
                   --in1 /mnt/scratch_dir/puntm/irods_strains/241023_VH01799_144_AAG5MJ2M5_0003/V273-64_S42_R1_001.fastq.gz \
                   --in2 /mnt/scratch_dir/puntm/irods_strains/241023_VH01799_144_AAG5MJ2M5_0003/V273-64_S42_R2_001.fastq.gz \
                   --out1 /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_pR1.fastq.gz \
                   --out2 /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_pR2.fastq.gz \
                   --unpaired1 /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_unpaired_joined.fastq.gz \
                   --unpaired2 /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_unpaired_joined.fastq.gz \
                   --html /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_fastp.html \
                   --json /mnt/scratch_dir/puntm/2024Spades/clean_fastq/V273-64_fastp.json \
                   --report_title "FastP report for sample V273-64" \
                   --detect_adapter_for_pe --thread 1 --cut_right --cut_window_size 5 --cut_mean_quality 28 --correction --length_required 50 \
                   > /mnt/scratch_dir/puntm/2024Spades/log/clean_fastq/clean_fastq_V273-64.log 2>&1