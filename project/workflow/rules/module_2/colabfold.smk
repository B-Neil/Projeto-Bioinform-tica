import os

rule colabfold:
    input:
        fasta = config["input_fasta"]
    output:
        directory(os.path.join(config["output_dir"], "colabfold"))
    threads: config["threads"]
    conda:
        "../../envs/module_2/colabfold.yaml"
    shell:
        """
        mkdir -p {output}
        colabfold_batch {input.fasta} {output} \
            --num-recycle 3 \
            --num-models 5 \
            --msa-mode single_sequence \
            --model-type alphafold2 \
            --rank auto \
            --use-dropout \
            --use-gpu-relax \
            --disable-unified-memory \
            --overwrite-existing-results
        """
