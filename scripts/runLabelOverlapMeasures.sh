#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "  $0 <outputDir> <subject> 

  Data is copied to \$TMPDIR to reduce network I/O

  Requires \$ANTSPATH

"
  exit 1
fi

outputDir=$1
subject=$2

if [[ ! -d "$TMPDIR" ]]; then
  echo " Define TMPDIR before running this script "
  exit 1
fi

cp ${outputDir}/${subject}/${subject}_WarpedLabels_*.nii.gz $TMPDIR

majorityLabels="${TMPDIR}/${subject}_MajorityLabels.nii.gz"

${ANTSPATH}ImageMath 3 $majorityLabels MajorityVoting ${TMPDIR}/${subject}_WarpedLabels_*.nii.gz

cp ${majorityLabels} ${outputDir}/${subject}/

its=( $(ls $TMPDIR | grep ${subject}_WarpedLabels | cut -d _ -f 3 | cut -d . -f 1) )

numIts=${#its[*]}  

for (( i=0; $i < $numIts; $((i++)) )); do 

  refIt=${its[i]}
  
  output="${outputDir}/${subject}/${subject}_MajorityLabelOverlap_${refIt}.csv"
  
  ref="${TMPDIR}/${subject}_WarpedLabels_${refIt}.nii.gz"

  ${ANTSPATH}LabelOverlapMeasures 3 $majorityLabels $ref $output

  for (( j=$((i+1)); $j < $numIts; $((j++)) )); do

    tarIt=${its[j]}  

    echo "Computing overlap between iterations $refIt and $tarIt"

    tar="${TMPDIR}/${subject}_WarpedLabels_${tarIt}.nii.gz"

    output="${outputDir}/${subject}/${subject}_PairwiseLabelOverlap_${refIt}_${tarIt}.csv"

    ${ANTSPATH}LabelOverlapMeasures 3 $ref $tar $output
  
  done
done
