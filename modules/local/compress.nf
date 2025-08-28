process COMPRESS {
    publishDir "${params.pubDir}/msavs", mode: 'copy'

    input:
    path(file_merged) 

    output:
    path("*.msav")

    script:
    def input_name = "$file_merged".endsWith("vcf.gz") ? "$file_merged".replaceAll('.vcf.gz', '') : "$file_merged.baseName"
    """
    minimac4 --compress-reference ${file_merged} > ${input_name}.msav
    """

}