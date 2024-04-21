#!/usr/bin/env nextflow

// tools: skesa, mlst, nextflow, quast
// conda create -n env_48 -c bioconda -c conda-forge skesa mlst quast nextflow

params.reads = "${PWD}"

workflow {
    read_pairs_channel = channel.fromFilePairs("${params.reads}/E*_{R1,R2}_phix.fq.gz", flat: true, checkIfExists: true)

    ASSEMBLE(read_pairs_channel)
    QUAST(ASSEMBLE.out)
    MLST(ASSEMBLE.out)
}

process ASSEMBLE {
    publishDir "${PWD}/asm", mode: 'copy'
    
    input:
    tuple val(sample_id), path(read_1), path(read_2)
    output:
    tuple val(sample_id), path("${sample_id}.skesa.fa")

    script:
    """
    mkdir -p ${PWD}/asm
    skesa --reads ${read_1},${read_2} > ${sample_id}.skesa.fa
    """
}

process QUAST {
    publishDir "${PWD}/quast", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)
    output:
    path 'quast_results'
    
    script:
    """
    mkdir -p ${PWD}/quast
    quast.py ${assembly}
    """
}

process MLST {
    publishDir "${PWD}/mlst", mode: 'copy'

    input:
    tuple val(sample_id), path(assembly)
    output:
    path("${sample_id}_MLST_Summary.tsv")

    script:
    """
    mkdir -p ${PWD}/mlst
    mlst ${assembly} > ${sample_id}_MLST_Summary.tsv
    """
}