# preRefPan-Workflow
This repository contains a pipeline for post-calling processing of mitochondrial DNA (mtDNA) VCF files, to prepare data for constructing a mtDNA reference panel. 

## Development
```
git clone https://github.com/LauSchoe/preRefPan-Workflow.git
cd pre-Refpan-Workflow
docker build -t prerefpan_image . # don't ignore the dot
```

## Run with test data
```
nextflow run main.nf -c test/test.config
```
