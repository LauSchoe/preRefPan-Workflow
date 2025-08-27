sample_data_ch = Channel.fromPath(params.sample_data)
alt_data = params.alt
indel_data = params.indel

include {FILTER_SAMPLE_DATA} from '../modules/local/filter_sample_data.nf'

workflow PRE_REFPAN {
    FILTER_SAMPLE_DATA(sample_data_ch, alt_data, indel_data)
}