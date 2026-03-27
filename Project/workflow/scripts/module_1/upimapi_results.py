#!/usr/bin/env python3

import sys
import pandas as pd


def is_empty(val):
    return pd.isna(val) or str(val).strip() == ""


# def build_extras(row, excluded_cols):
#     parts = []
#     for col, val in row.items():
#         if col in excluded_cols:
#             continue
#         if not is_empty(val):
#             parts.append(f"{col}: {val}")
#     return "; ".join(parts)


def should_remove(row):
    protein_name = str(row["Protein names"])

    cond_protein = "Uncharacterized protein" in protein_name

    cond_empty_info = (
        is_empty(row["Function [CC]"]) and
        is_empty(row["Gene Ontology (GO)"]) and
        is_empty(row["EC number"]) and
        is_empty(row["Pfam"])
    )

    return cond_protein and cond_empty_info


def main(input_tsv, output_tsv):
    df = pd.read_csv(input_tsv, sep="\t")

    # Colunas a manter agora inclui Pfam
    keep_cols = [
        "qseqid",
        "Protein names",
        "Gene Ontology (GO)",
        "EC number",
        "Pfam",
    ]

    missing = [c for c in keep_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Colunas em falta no ficheiro: {missing}")

    # -------- FILTRO --------
    df = df[~df.apply(should_remove, axis=1)].copy()

    excluded = set(keep_cols)

    # # Criar extra
    # df["extra"] = df.apply(lambda r: build_extras(r, excluded), axis=1)

    # Novo dataframe
    new_df = df[keep_cols].copy()
    # new_df["extra"] = df["extra"]

    # Adicionar tool
    new_df["tool"] = "UPIMAPI"

    # Ordem final das colunas
    new_df = new_df[
        [
            "qseqid",
            "tool",
            "Protein names",
            "Gene Ontology (GO)",
            "EC number",
            "Pfam",
        ]
    ]

    new_df.to_csv(output_tsv, sep="\t", index=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso:")
        print("  python extract_upimapi.py input.tsv output.tsv")
        sys.exit(1)

    main(sys.argv[1], sys.argv[2])