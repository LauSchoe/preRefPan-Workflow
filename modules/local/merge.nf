process MERGE {
    publishDir "${params.pubDir}", mode: 'copy'

    input: 
    path filtered_vcf_ch
    path filtered_tbi_ch
    val (AC)

    output:
    path("*_merged.vcf.gz"), emit: file_merged

    script:
    """
    # merge all files
    bcftools merge -0 ${filtered_vcf_ch} |
    # add AC, AN, AF
    bcftools +fill-tags -- -t AC,AN,AF |
    # split multiallelic sites
    bcftools norm -m - |
    # filter for AC <= AC
    bcftools view -e 'INFO/AC<=${AC}' -Oz -o ${params.project}_AC${AC}_merged.vcf.gz
    """


}