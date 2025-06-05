import os

rule upimapi:
    input:
        fasta = config["input_fasta"]
    output:
        "results/upimapi_results.tsv"
    threads:
        config["threads"]
    conda:
        "../../envs/module_1/upimapi.yaml"
    shell:
        """
        mkdir -p results/upimapi
        upimapi -i {input.fasta} -t {threads}
        """