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

    keep_cols = [
        "qseqid",
        "Protein names",
        "Gene Ontology (GO)",
        "EC number",
        "Function [CC]",
    ]

    missing = [c for c in keep_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Colunas em falta no ficheiro: {missing}")

    excluded = set(keep_cols)

    # Criar coluna extra
    df["extra"] = df.apply(lambda r: build_extras(r, excluded), axis=1)

    # Criar novo dataframe
    new_df = df[keep_cols].copy()
    new_df["extra"] = df["extra"]

    # Adicionar coluna tool
    new_df["tool"] = "UPIMAPI"

    # ORDEM FINAL DAS COLUNAS
    new_df = new_df[
        [
            "qseqid",
            "tool",
            "Protein names",
            "Function [CC]",
            "Gene Ontology (GO)",
            "EC number",
            "extra",
        ]
    ]

    new_df.to_csv(output_tsv, sep="\t", index=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso:")
        print("  python extract_upimapi.py input.tsv output.tsv")
        sys.exit(1)

    input_tsv = sys.argv[1]
    output_tsv = sys.argv[2]

    main(input_tsv, output_tsv)