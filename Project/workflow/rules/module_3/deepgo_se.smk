fasta = config["file_path"]
db_dir = config["database_dir"]
output_dir = config["output_dir"]
filename = config["filename"]

rule clone_deepgo:
    output:
        "data/deepgo2/predict.py",
    conda:
        "../../envs/module_3/deepgo_se.yaml"
    shell:
        """
        cd data
        git clone https://github.com/bio-ontology-research-group/deepgo2.git
        """

rule download_pretrainded_models:
    input:
        "data/deepgo2/predict.py"
    output:
        "data/deepgo2/.data_download"
    conda:
        "../../envs/module_3/deepgo_se.yaml"
    shell:
        """
        cd data/deepgo2
        if [ ! -d "data" ]; then
            gdown 1L94pq7hszlv86hYcBy8C0NZY0c3DxR-n
            tar -xzf data.tar.gz && rm data.tar.gz
        fi
        touch .data_download
        """

rule deepgo2:
    input:
        "data/deepgo2/predict.py",
        "data/deepgo2/.data_download"
    output:
        f"{output_dir}/deepgo2/{filename}_preds_mf.tsv"
    conda:
        "../../envs/module_3/deepgo_se.yaml"
    shell:
        f"""
        mkdir -p {output_dir}/deepgo2
        cp {fasta} {output_dir}/deepgo2
        cd data/deepgo2
        python predict.py -if ../../{output_dir}/deepgo2/{filename}.fasta
        cd ../../{output_dir}/deepgo2/
        gunzip {filename}_preds_bp.tsv.gz
        gunzip {filename}_preds_cc.tsv.gz
        gunzip {filename}_preds_mf.tsv.gz
        rm {filename}_esm.pkl {filename}.fasta
        """