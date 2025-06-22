import os

db_dir = config["database_dir"]
eggnog_db_dir = os.path.join(db_dir, "eggnogmapper")
eggnog_db_done = os.path.join(eggnog_db_dir, "eggnog.db.done")

rule download_eggnog_db:
    output:
        eggnog_db_done
    conda:
        "../../envs/module_1/eggnogmapper.yaml"
    shell:
        """
        mkdir -p {eggnog_db_dir}
        download_eggnog_data.py -y --data_dir {eggnog_db_dir}
        touch {output}
        """

rule eggnog_mapper:
    input:
        fasta = config["file_path"],
        db_done = eggnog_db_done,
        output_dir = config["output_dir"]
    output:
        annotations = os.path.join(config["output_dir"], "eggnogmapper_results", "eggnog_mapper_results.emapper.annotations")
    threads: config["threads"]
    conda:
        "../../envs/module_1/eggnogmapper.yaml"
    shell:
        """
        mkdir -p {input.output_dir}/eggnogmapper_results
        emapper.py -i {input.fasta} \
                   --output eggnog_mapper_results \
                   --output_dir {input.output_dir}/eggnogmapper_results \
                   --data_dir {eggnog_db_dir} \
                   --cpu {threads} \
                   --usemem \
                   --go_evidence all
        """
