process CREATE_YAML {
    publishDir "${params.pubDir}/reference_panel", mode: 'copy'

    input:
    val(filtered_count)
    path(sites_file)
    path(msav_file)

    output:
    file("cloudgene.yaml")

    script:

    """
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
    echo "        samples: ${filtered_count}" >> cloudgene.yaml
    echo "      - id: "off"" >> cloudgene.yaml
    echo "        name: OFF" >> cloudgene.yaml
    echo "        samples: -1" >> cloudgene.yaml
    """
}