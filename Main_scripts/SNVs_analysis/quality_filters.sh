#!/bin/sh

# After variant calling of the SNVs with HaplotypeCaller, this script applies quality filters to the resulting compressed VCFs. 
# These filters include a variant quality filter greater than 20, a depth of coverage greater than 28, alternative allele ratio
# greater than 29, and the PASS filter if a given position passed all GATK quality filters, i.e., a call was made at that position.

# DIRECTORIES
# Directory of bcftools and the initial sample files
BCFTOOLS_DIR="/mnt/beegfs/home/mimarbor/singularity_cache/depot.galaxyproject.org-singularity-bcftools-1.16--hfe4b78e_1.img"
SAMPLES_DIR="/mnt/beegfs/home/serbaugon/Samples"

# Creation of a new directory to store the output files after applying the filters
mkdir -p $SAMPLES_DIR/Quality_Filters
FILTERS_DIR="$SAMPLES_DIR/Quality_Filters"

# FILTERING COMMANDS
# Quality filter
mkdir -p $FILTERS_DIR/QUAL
QUAL_DIR="$FILTERS_DIR/QUAL"

for input in $SAMPLES_DIR/*.vcf.gz; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  singularity run $BCFTOOLS_DIR bcftools view -e 'QUAL<=20' $input -o $QUAL_DIR/$name.QUAL.vcf.gz
  echo "QUAL filter applied to file: $file"
done

# Coverage depth filter 
mkdir -p $FILTERS_DIR/DP
DP_DIR="$FILTERS_DIR/DP"

for input in $QUAL_DIR/*.vcf.gz; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  singularity run $BCFTOOLS_DIR bcftools view -e 'FMT/DP<=28' $input -o $DP_DIR/$name.DP.vcf.gz
  echo "FMT/DP filter applied to file: $file"
done

# Ratio of alternative alleles filter
mkdir -p $FILTERS_DIR/ADALT
ADALT_DIR="$FILTERS_DIR/ADALT"

for input in $DP_DIR/*.vcf.gz; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  singularity run $BCFTOOLS_DIR bcftools filter -i '(FORMAT/AD[0:1]*100)/(FORMAT/AD[0:0]+FORMAT/AD[0:1]) >= 29' $input -o $ADALT_DIR/$name.ADALT.vcf.gz
  echo "ADALT filter applied to file: $file"
done

# PASS filter
mkdir -p $FILTERS_DIR/PASS
PASS_DIR="$FILTERS_DIR/PASS"

for input in $ADALT_DIR/*.vcf.gz; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  singularity run $BCFTOOLS_DIR bcftools view -f PASS $input -o $PASS_DIR/$name.PASS.vcf.gz
  echo "PASS filter applied to file: $file"
done
