# trunc_fasta_header.py

import sys

input_fasta = sys.argv[1]
output_fasta = sys.argv[2]

with open(input_fasta, "r") as fin, open(output_fasta, "w") as fout:
    for line in fin:
        if line.startswith(">"):
            header = line[1:].strip().split()[0]  # mantém só até ao primeiro espaço
            fout.write(f">{header}\n")
        else:
            fout.write(line)
