process CREATE_YAML {
    publishDir "${params.pubDir}/reference_panel", mode: 'copy'

    input:
    file(sites_file)
    file(msav_file)
    file(file_merged)

    output:
    path("cloudgene.yaml"), emit: cloudgene_file


    script:
    """
    sample_count=\$(bcftools query -l ${file_merged} | wc -l)
    echo "name: ${params.project}" > cloudgene.yaml
    echo "version: ${params.version}" >> cloudgene.yaml
    echo "website: http://imputationserver.sph.umich.edu" >> cloudgene.yaml
    echo "category: RefPanel" >> cloudgene.yaml
    echo "id: ${params.id}-v${params.version}-${params.build}" >> cloudgene.yaml

    echo "properties:" >> cloudgene.yaml
    echo "  id: ${params.id}" >> cloudgene.yaml
    echo "  build: ${params.build}" >> cloudgene.yaml
    echo "  genotypes: \\\${CLOUDGENE_APP_LOCATION}/msavs/${msav_file}" >> cloudgene.yaml
    echo "  sites: \\\${CLOUDGENE_APP_LOCATION}/sites/${sites_file}" >> cloudgene.yaml
    echo "  populations:" >> cloudgene.yaml
    echo "      - id: all" >> cloudgene.yaml
    echo "        name: all" >> cloudgene.yaml
    echo "        samples: \$sample_count" >> cloudgene.yaml
    echo "      - id: "off"" >> cloudgene.yaml
    echo "        name: OFF" >> cloudgene.yaml
    echo "        samples: -1" >> cloudgene.yaml
    """
}