process CREATE_ZIP {

    publishDir  "${params.pubDir}", mode: 'copy'
    input:
    file(msav_file)
    file(sites_file)
    file(sites_tabix)
    file(cloudgene_file)

    output:
    path("*.zip")

    script: 
    def zip_name = "${params.project}.zip"
    """
    mkdir temp_refpan
    mkdir -p temp_refpan/msavs
    mkdir -p temp_refpan/sites
    cp ${msav_file} temp_refpan/msavs
    cp ${sites_file} temp_refpan/sites
    cp ${sites_tabix} temp_refpan/sites
    cp ${cloudgene_file} temp_refpan

    # zip files
    if [[ "${params.encryption.enabled}" == true ]] 
    then 
        7z a -tzip ${zip_name} ./temp_refpan/*
        rm -rf temp_refpan
    fi

    """
}