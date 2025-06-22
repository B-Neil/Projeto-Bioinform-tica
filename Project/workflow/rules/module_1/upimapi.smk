import os

rule upimapi:
    input:
        fasta = config["file_path"],
        db_dir = config["database_dir"],
        output_dir=config["output_dir"]
    output:
        "results/upimapi/UPIMAPI_results.tsv"
    threads:
        config["threads"]
    conda:
        "../../envs/module_1/upimapi.yaml"
    shell:
        """
        mkdir -p {input.db_dir}/upimapi_db
        mkdir -p {input.output_dir}/upimapi
        #upimapi --show-available-fields
        upimapi -i {input.fasta} -o {input.output_dir}/upimapi --database uniprot -rd {input.db_dir}/upimapi_db --diamond-mode fast --columns "Protein names&Gene Ontology (GO)&Function [CC]&EC number&Annotation&Protein families&Pfam" -t {threads}
        """