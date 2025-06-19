# trunc_fasta_header.py
import sys
import os

input_fasta = sys.argv[1]
tmp_fasta = input_fasta + ".tmp"

with open(input_fasta, "r") as fin, open(tmp_fasta, "w") as fout:
    for line in fin:
        if line.startswith(">"):
            header = line[1:].strip().split()[0]
            fout.write(f">{header}\n")
        else:
            fout.write(line)

os.replace(tmp_fasta, input_fasta)
