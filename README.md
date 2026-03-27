# Projeto-Bioinformática

# 🧬 Protein Annotation Pipeline

This repository contains a **modular** and **reproducible** protein annotation pipeline implemented in **Snakemake**, integrating tools based on **homology**, **structure**, and **machine learning**.

---

## 📁 Project Structure

```plaintext
project/
├── config/
│   └── config.yaml                  # Pipeline configuration
├── data/
│   ├── databases/                   # Tool databases
│   └── proteins/
│       ├── example.fasta            # Example FASTA file
│       └── trunc_fasta.py           # Script to truncate the proteins name
├── results/                         # Outputs organized by tool/module
├── workflow/
│   ├── envs/
│   │   ├── module_1/                # Conda environments for module 1 (homology)
│   │   ├── module_2/                # Conda environments for module 2 (structure)
│   │   └── module_3/                # Conda environments for module 3 (machine learning)
│   ├── rules/
│   │   ├── module_1/                # Snakemake rules for module 1 (homology)
│   │   ├── module_2/                # Snakemake rules for module 2 (structure)
│   │   └── module_3/                # Snakemake rules for module 3 (machine learning)
└── Snakefile                        # Snakefile           
```

---

## ⚙️ Requisitos

- Linux / WSL
- Snakemake==9.5.1
- Conda

---

## 🚀 Módulos da Pipeline

### 1. Homology-based annotation
- Tools: `reCOGnizer`, `UPIMAPI`, `eggNOG-mapper`

### 2. Structure-based annotation
- Tools: `ColabFold`, `FoldSeek`, `DeepFRI`

### 3. Machine learning-based annotation
- Tools: `DeepGO2`, `Clean EC`

---

## 🔧 Installation
```bash
git clone https://github.com/B-Neil/Projeto-Bioinform-tica.git
cd Projeto-Bioinform-tica/Project

```
## ▶️ Usage

1. Place your protein sequences in a FASTA file under `data/proteins/` (e.g., `example.fasta`)
2. Edit `config/config.yaml` to set the right parameters
3. Run the pipeline using: 

```bash
#N = Number of cores to be used
snakemake --use-conda --cores N --conda-frontend conda
