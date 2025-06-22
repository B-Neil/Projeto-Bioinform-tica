import os
output_dir = config["output_dir"]

rule recognizer:
    input:
        fasta = config["file_path"],
        db_dir = config["database_dir"],
        output_dir = config["output_dir"]
    output:
        f"{output_dir}/recognizer_results/reCOGnizer_results.tsv"
    threads: config["threads"]
    conda:
        "../../envs/module_1/recognizer.yaml"
    shell:
        """
        mkdir -p {input.db_dir}
        mkdir -p {input.output_dir}/recognizer_results
        SEQ_COUNT=$(grep -c '^>' {input.fasta})
        FINAL_THREADS=$(( {threads} < SEQ_COUNT ? {threads} : SEQ_COUNT ))
        echo "Using $FINAL_THREADS threads (out of {threads}) for $SEQ_COUNT sequences"
        recognizer -f {input.fasta} -rd {input.db_dir}/recognizer_db -o {input.output_dir}/recognizer_results -t $FINAL_THREADS
        """
