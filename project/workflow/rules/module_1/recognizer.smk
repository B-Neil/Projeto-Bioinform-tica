import os

rule recognizer:
    input:
        fasta = config["input_fasta"],
        db_dir = config["database_dir"]
    output:
        "results/recognizer_results/reCOGnizer_results.tsv"
    threads: config["threads"]
    conda:
        "../../envs/module_1/recognizer.yaml"
    shell:
        """
        mkdir -p results/recognizer_results
        SEQ_COUNT=$(grep -c '^>' {input.fasta})
        FINAL_THREADS=$(( {threads} < SEQ_COUNT ? {threads} : SEQ_COUNT ))
        echo "Using $FINAL_THREADS threads (out of {threads}) for $SEQ_COUNT sequences"
        recognizer -f {input.fasta} -o results/recognizer_results -t $FINAL_THREADS
        """
