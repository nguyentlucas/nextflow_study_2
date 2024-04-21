# nextflow_study_2
Another study of using nextflow to create a simple pipeline where processes are run parallely if they have the same input.

---
# usage

**Environment setup:**

conda create -n env_48 -c bioconda -c conda-forge skesa mlst quast nextflow
conda activate env_48

**Nextflow script usasge:**

nextflow run parallel_asm_mlst.nf --reads <directory with paired-end reads>

**example:**

nextflow run parallel_asm_mlst.nf --reads .
