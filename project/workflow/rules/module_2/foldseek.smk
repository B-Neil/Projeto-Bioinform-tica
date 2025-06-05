rule download_foldseek_pdb:
    output:
        "data/databases/foldseek_db/.pdb_ready",
        "data/databases/foldseek_db"
    conda:
        "../../envs/module_2/foldseek.yaml"
    shell:
        """
        mkdir -p data/databases/foldseek_db
        rm -f data/databases/foldseek_db/pdb  # evita conflito se já existe como diretório
        cd data/databases/foldseek_db
        foldseek databases PDB pb tmp

        touch .pdb_ready
        """



rule foldseek_easy_search:
    input:
        "results/colabfold",
        "data/databases/foldseek_db",
        "data/databases/foldseek_db/.pdb_ready"
    output:
        "results/foldseek/output_easy_search.m8"
    conda:
        "../../envs/module_2/foldseek.yaml"
    shell:
        """
        mkdir -p results/foldseek/tmp
        foldseek easy-search results/colabfold data/databases/foldseek_db/pb results/foldseek/output_easy_search.m8 \
            results/foldseek/tmp --threads 10
        """
