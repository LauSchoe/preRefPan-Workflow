process SITES {
    publishDir "${params.pubDir}/sites", mode: 'copy'

    input:
    path(file_merged) 

    output:
    path("*.legend.gz")
    path("*.legend.gz.tbi")

    script:
    def input_name = "$file_merged".endsWith("vcf.gz") ? "$file_merged".replaceAll('.vcf.gz', '') : "$file_merged.baseName"
    """
    echo "ID	CHROM	POS REF	ALT	AAF_ALL" > header
    bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%AC\t%AN\n' ${file_merged} \
    | awk -F"\t" 'BEGIN { OFS = "\t" } { print \$1":"\$2, \$1, \$2, \$3, \$4, \$5/\$6 }' \
    | cat header - \
    | bgzip > ${input_name}.legend.gz
    tabix -s 2 -b 3 -e 3 -S 1 ${input_name}.legend.gz -f
    """    
}