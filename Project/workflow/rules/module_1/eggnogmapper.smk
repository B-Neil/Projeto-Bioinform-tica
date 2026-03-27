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
        cd {eggnog_db_dir}
        wget -nc http://eggnog5.embl.de/download/emapperdb-5.0.2/eggnog.db.gz
        gunzip eggnog.db.gz
        wget -nc http://eggnog5.embl.de/download/emapperdb-5.0.2/eggnog.taxa.tar.gz
        gunzip eggnog.taxa.tar.gz
        wget -nc http://eggnog5.embl.de/download/emapperdb-5.0.2/eggnog_proteins.dmnd.gz
        gunzip eggnog_proteins.dmnd.gz
        wget -nc http://eggnog5.embl.de/download/emapperdb-5.0.2/mmseqs.tar.gz
        gunzip mmseqs.tar.gz
        wget -nc http://eggnog5.embl.de/download/emapperdb-5.0.2/pfam.tar.gz
        gunzip pfam.tar.gz
        

        touch dbs.done
        """

rule eggnog_mapper:
    input:
        "data/databases/eggnogmapper/dbs.done",
        fasta = config["file_path"],
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
                   --go_evidence all \
                   --dbmem
        """
