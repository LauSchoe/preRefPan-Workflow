#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

if(params.outdir == null) {
    params.pubDir = "output/${params.project}"
} else {
    params.pubDir = params.outdir
}

include {PRE_REFPAN} from './workflows/pre_refpan'

workflow {
    PRE_REFPAN ()
}