#!/bin/bash

# DIRECTORIES
SAMPLES_SNPs="/mnt/beegfs/home/serbaugon/Samples/Post_VEP/SNPs/PROTEIN_CODING"
SAMPLES_INDELS="/mnt/beegfs/home/serbaugon/Samples/Post_VEP/Indels/NOT_INTRONS"

mkdir -p /mnt/beegfs/home/serbaugon/Samples/Post_VarSome
POST_VARSOME_DIR="/mnt/beegfs/home/serbaugon/Samples/Post_VarSome"


# Classification with VarSome
# For SNPs:
mkdir -p $POST_VARSOME_DIR/SNPs
POST_VARSOME_SNPs_DIR="$POST_VARSOME_DIR/SNPs"

for input in $SAMPLES_SNPs/*.vcf; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  varsome_api_annotate_vcf.py -k 'dRc22Vd%IvCVgOY42IVO8!vbcSthl9t@JXOe2eJ8' -g hg38 -p add-ACMG-annotation=1 -i $input -o $POST_VARSOME_SNPs_DIR/${name}_VarSome.vcf -u 'https://api.varsome.com/'
  echo "Classified file: $file"
done

# For indels:
mkdir -p $POST_VARSOME_DIR/Indels
POST_VARSOME_INDELS_DIR="$POST_VARSOME_DIR/Indels"

for input in $SAMPLES_INDELS/*.vcf; do
  file="$(basename "$input")" 
  name="$(echo $file | cut -d "." -f 1)"
  varsome_api_annotate_vcf.py -k 'dRc22Vd%IvCVgOY42IVO8!vbcSthl9t@JXOe2eJ8' -g hg38 -p add-ACMG-annotation=1 -i $input -o $POST_VARSOME_INDELS_DIR/${name}_VarSome.vcf -u 'https://api.varsome.com/'
  echo "Classified file: $file"
done
