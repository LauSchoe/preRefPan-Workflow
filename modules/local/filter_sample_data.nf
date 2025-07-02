process FILTER_SAMPLE_DATA {

    input:
    path(sample_data)
    path(alt)
    path(ref)
    path(indel)
    output:
    path("*filtered.vcf.gz")

    script:
    """
    for i in ${sample_data}
    do 
        sample_name=$(${i}.baseName .vcf.gz)
        

    
    """


}