rule download_deepfri:
    output:
        "data/deepfri_src/setup.py"
    shell:
        """
        if [ ! -e data/deepfri_src/setup.py ]; then
            rm -rf data/deepfri_src
            git clone https://github.com/flatironinstitute/DeepFRI.git data/deepfri_src
        fi
        """

rule download_deepfri_models:
    input:
        "data/deepfri_src/setup.py"
    output:
        "data/deepfri_src/trained_models/DeepCNN-MERGED_biological_process.hdf5"
    shell:
        """
        wget -P data/deepfri_src https://users.flatironinstitute.org/~renfrew/DeepFRI_data/newest_trained_models.tar.gz
        cd data/deepfri_src
        tar -xzf newest_trained_models.tar.gz
        """

rule deepfri_requirements:
    input:
        "data/deepfri_src/setup.py"
    output:
        "data/deepfri_src/.requirements_done"
    shell:
        """
        cd data/deepfri_src
        pip install . --no-deps
        touch .requirements_done
        """

rule deepfri:
    input:
        "data/deepfri_src/trained_models/DeepCNN-MERGED_biological_process.hdf5",
        "data/deepfri_src/.requirements_done",
        "data/deepfri_src/setup.py"
    output:
        "results/deepfri/output_mf.csv"
    conda:
        "../../envs/module_2/deepfri.yaml"
    shell:
        """
        mkdir -p results/deepfri
        cd data/deepfri_src
        python predict.py --fasta_fn ../proteins/subset_f.fasta -ont mf -v
        mv *.json ../../results/deepfri/
        mv *.csv ../../results/deepfri/
        """
