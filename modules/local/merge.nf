process MERGE {
    publishDir "${params.pubDir}/merge", mode: 'copy'

    input: 
    path filtered_vcf_ch
    path filtered_tbi_ch
    val (AC)
    path subset_sample_file

    output:
    path("*_merged.vcf.gz"), emit: file_merged

    script:
    """
    # merge all files
    bcftools merge -0 ${filtered_vcf_ch} -Oz -o merged.vcf.gz

    # select subset of samples
    if [[ -n "${params.subset_sample_file}" ]]
    then
        bcftools view -S $subset_sample_file merged.vcf.gz | bgzip > tmp.merged.vcf.gz
    else
        mv merged.vcf.gz tmp.merged.vcf.gz
    fi

    # sort files
    bcftools query -l tmp.merged.vcf.gz | sort > sorted_samples.txt
    bcftools reheader -s sorted_samples.txt tmp.merged.vcf.gz |
    # add AC, AN, AF
    bcftools +fill-tags -- -t AC,AN,AF |
    # split multiallelic sites
    bcftools norm -m - |
    # filter for AC <= AC
    bcftools view -e "INFO/AC<${AC}" -Oz -o chrMT_${params.project}_AC${AC}_merged.vcf.gz
    """


}