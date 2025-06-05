import os

db_base = config["database_dir"]
eggnog_db_dir = os.path.join(db_base, "eggnogmapper")
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
        fasta = config["input_fasta"],
        db_done = eggnog_db_done
    output:
        annotations = os.path.join(config["output_dir"], "eggnogmapper_results", "eggnog_mapper_results.emapper.annotations")
    threads: config["threads"]
    conda:
        "../../envs/module_1/eggnogmapper.yaml"
    shell:
        """
        mkdir -p {config[output_dir]}/eggnogmapper_results
        emapper.py -i {input.fasta} \
                   --output eggnog_mapper_results \
                   --output_dir {config[output_dir]}/eggnogmapper_results \
                   --data_dir {eggnog_db_dir} \
                   --cpu {threads} \
                   --usemem \
                   --go_evidence all
        """
