import subprocess

cmd = [
    "snakemake",
    "--use-conda",
    "--cores", "8",
    "--conda-frontend", "conda",
    "--keep-going"
]

subprocess.run(cmd)