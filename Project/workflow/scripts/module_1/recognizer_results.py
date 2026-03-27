#!/usr/bin/env python3

import sys
import pandas as pd


def build_extras(row, excluded_cols):
    parts = []
    for col, val in row.items():
        if col in excluded_cols:
            continue
        if pd.notna(val) and str(val).strip() != "":
            parts.append(f"{col}: {val}")
    return "; ".join(parts)


def main(input_tsv, output_tsv):
    df = pd.read_csv(input_tsv, sep="\t")

    # Colunas a manter e novos nomes
    keep_map = {
        "qseqid": "qseqid",
        "DB description": "Protein Information", 
        "EC number": "EC numbers",
        "evalue": "e-value",
    }

    # Verificação básica
    missing = [col for col in keep_map if col not in df.columns]
    if missing:
        raise ValueError(f"Colunas em falta no ficheiro: {missing}")

    excluded = set(keep_map.keys())

    # Criar coluna extra
    df["extra"] = df.apply(lambda r: build_extras(r, excluded), axis=1)

    # Novo dataframe apenas com as colunas desejadas
    new_df = pd.DataFrame({
        new_name: df[old_name] for old_name, new_name in keep_map.items()
    })
    new_df["extra"] = df["extra"]

    # Escrever TSV final
    new_df.to_csv(output_tsv, sep="\t", index=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso:")
        print("  python extract_recognizer.py input.tsv output.tsv")
        sys.exit(1)

    input_tsv = sys.argv[1]
    output_tsv = sys.argv[2]

    main(input_tsv, output_tsv)