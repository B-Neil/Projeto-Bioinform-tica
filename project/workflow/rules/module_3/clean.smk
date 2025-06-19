fasta = config["file_path"]
db_dir = config["database_dir"]
output_dir = config["output_dir"]
filename = config["filename"]


rule download_clean:
    output:
        "data/clean_src/.cloned"
    shell:
        """
        if [ ! -f data/clean_src/app/build.py ]; then
            rm -rf data/clean_src  # remove diretório corrompido ou incompleto
            git clone https://github.com/tttianhao/CLEAN.git data/clean_src
        fi
        touch {output}
        """


rule install_clean:
    input:
        "data/clean_src/.cloned"
    output:
        "data/clean_src/app/.installed"
    conda:
        "../../envs/module_3/clean.yaml"
    shell:
        """
        cd data/clean_src/app
        python build.py install
        touch .installed
        """



rule esm:
    input:
        "data/clean_src/app/.installed"
    output:
        "data/clean_src/app/.installed_esm"
    conda:
        "../../envs/module_3/clean.yaml"
    shell:
        """
        cd data/clean_src/app
        [ -d esm ] || git clone https://github.com/facebookresearch/esm.git
        touch .installed_esm
        """


rule download_clean_models:
    output:
        "data/clean_src/app/data/pretrained/.models",
        "data/clean_src/app/data/pretrained/split100.pth"
    conda:
        "../../envs/module_3/clean.yaml"
    shell:
        """
        mkdir -p data/clean_src/app/data/pretrained

        gdown https://drive.google.com/uc?id=1kwYd4VtzYuMvJMWXy6Vks91DSUAOcKpZ \
              -O data/clean_src/app/data/pretrained/

        cd data/clean_src/app/data/pretrained
        unzip -j pretrained.zip
        touch .models
        """




rule clean_infer:
    input:
        "data/clean_src/app/.installed",
        "data/clean_src/app/.installed_esm",
        "data/clean_src/app/data/pretrained/split100.pth",
    output:
        f"{output_dir}/clean/{filename}_maxsep.csv"
    conda:
        "../../envs/module_3/clean.yaml"
    shell:
        f"""
        mkdir -p {output_dir}/clean
        cp {fasta} data/clean_src/app/data/inputs
        cd data/clean_src/app
        mkdir -p data/esm_data

        LIBIOMP_PATH=$(find $(dirname $(dirname $(which python)))/lib -name "libiomp5.so" | head -n 1)
        export LD_PRELOAD=$LIBIOMP_PATH 

        python CLEAN_infer_fasta.py --fasta_data {filename}
        cp {output_dir}/inputs/{filename}_maxsep.csv ../../../{output_dir}/clean
        """





