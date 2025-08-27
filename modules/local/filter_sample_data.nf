process FILTER_SAMPLE_DATA {
    publishDir "${params.pubDir}", mode: 'copy'

    input:
    path(sample_data)
    val (alt_data)
    val (indel_data)

    output:
    file("*_filtered.vcf.gz")
    file("*_filtered.vcf.gz.tbi")

    script:
    def sample_name = sample_data.baseName
    
    """
    #!/bin/bash

    # create file without indels
    if [[ ${indel_data} == "noindel" ]]; then
        bcftools view -V indels ${sample_data} -O z -o tmp_${sample_name}.vcf.gz
    else
        cp ${sample_data} tmp_${sample_name}.vcf.gz
    fi
    
    # decompose biallelic block substituations into constituent SNPs
    vt decompose_blocksub tmp_${sample_name}.vcf.gz |
    # remove contig from header except ##contig=<ID=chrM,length=16569>, if found: change Type=String to Float
	awk '/^##contig=/ { if (/ID=chrM/) print; next } {print} ' | sed 's/ID=AF,Number=1,Type=String/ID=AF,Number=1,Type=Float/' |
    # create file without heteroplasmic samples
    bcftools filter -i '(FMT/AF>=${alt_data})' |
    # set GT to ALT (1) when AF >= alt
	bcftools +setGT -- -t q -i '(FMT/AF>=${alt_data})' -n c:1 |
    # change chrM to chrMT
	bcftools annotate --rename-chrs <(echo -e "chrM\tchrMT") |
	# due to decompose, VCF includes duplicates both having AF>=alt. For ref panel creation both correspond to 1, therefore only 1 position is required
	bcftools norm -d exact -Oz -o ${sample_name}_${alt_data}_${indel_data}_filtered.vcf.gz 
    # create index of filtered file
	tabix -p vcf ${sample_name}_${alt_data}_${indel_data}_filtered.vcf.gz

    """
}