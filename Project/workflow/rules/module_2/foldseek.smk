fasta = config["file_path"]
db_dir = config["database_dir"]
output_dir = config["output_dir"]



rule download_foldseek_pdb:
    output:
        f"{db_dir}/foldseek_db/.pdb_ready",
    conda:
        "../../envs/module_2/foldseek.yaml"
    shell:
        f"""
        mkdir -p {db_dir}/foldseek_db
        rm -f {db_dir}/foldseek_db/pdb
        cd {db_dir}/foldseek_db
        foldseek databases PDB pb tmp

        touch .pdb_ready
        """



rule foldseek_easy_search:
    input:
        f"{output_dir}/colabfold/config.json",
        f"{db_dir}/foldseek_db/.pdb_ready"
    output:
        f"{output_dir}/foldseek/output_easy_search.m8"
    conda:
        "../../envs/module_2/foldseek.yaml"
    shell:
        f"""
        mkdir -p {output_dir}/foldseek/tmp
        foldseek easy-search {output_dir}/colabfold {db_dir}/foldseek_db/pb {output_dir}/foldseek/output_easy_search.m8 \
            {output_dir}/foldseek/tmp --threads 10
        """