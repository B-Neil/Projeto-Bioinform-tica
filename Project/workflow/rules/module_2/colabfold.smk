import os
output_dir = config["output_dir"]
filename = config["filename"]
fasta = config["file_path"]

rule colabfold:
    input:
        fasta = config["file_path"],
        output_dir = config["output_dir"],

    output:
        f"{output_dir}/colabfold/config.json"
    threads: config["threads"]
    conda:
        "../../envs/module_2/colabfold.yaml"
    shell:
        f"""
        cd data/proteins
        python trunc_fasta.py ../../{fasta}
        cd ../..
        """

        """
        mkdir -p {input.output_dir}/colabfold
        colabfold_batch {input.fasta} {input.output_dir}/colabfold \
            --num-recycle 3 \
            --num-models 1 \
            --msa-mode single_sequence \
            --model-type alphafold2 \
            --rank auto \
            --use-dropout \
            --use-gpu-relax \
            --disable-unified-memory \
            --overwrite-existing-results
        """
