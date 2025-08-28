sample_data_ch = Channel.fromPath(params.sample_data)
alt_data = params.alt
indel_data = params.indel
AC = params.allele_count

include {FILTER_SAMPLE_DATA} from '../modules/local/filter_sample_data.nf'
include {MERGE} from '../modules/local/merge.nf'

workflow PRE_REFPAN {
    FILTER_SAMPLE_DATA(sample_data_ch, alt_data, indel_data)

    filtered_vcf_ch = FILTER_SAMPLE_DATA.out.filtered_vcf.collect()
    filtered_tbi_ch = FILTER_SAMPLE_DATA.out.filtered_tbi.collect()

    MERGE(filtered_vcf_ch, filtered_tbi_ch, AC)
}