sample_data_ch = Channel.fromPath(params.sample_data)
alt_data = params.alt
indel_data = params.indel
AC = params.allele_count

include {FILTER_SAMPLE_DATA} from '../modules/local/filter_sample_data.nf'
include {MERGE} from '../modules/local/merge.nf'
include {SITES} from '../modules/local/sites.nf'
include {COMPRESS} from '../modules/local/compress.nf'
include {CREATE_YAML} from '../modules/local/create_yaml.nf'

workflow PRE_REFPAN {

    def subset_sample_file = []

    if (params.subset_sample_file != '') {
        subset_sample_file = file(params.subset_sample_file, checkIfExists: true)
    }

    FILTER_SAMPLE_DATA(sample_data_ch, alt_data, indel_data)

    filtered_vcf_ch = FILTER_SAMPLE_DATA.out.filtered_vcf.collect()
    filtered_tbi_ch = FILTER_SAMPLE_DATA.out.filtered_tbi.collect()

    MERGE(filtered_vcf_ch, filtered_tbi_ch, AC, subset_sample_file)

    SITES(MERGE.out.file_merged)

    COMPRESS(MERGE.out.file_merged)

    //filtered_count = FILTER_SAMPLE_DATA.out.filtered_vcf.count()

    CREATE_YAML(SITES.out.sites_file, COMPRESS.out.msav_file, MERGE.out.file_merged)
}