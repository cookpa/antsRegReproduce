#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo " $0 <outputDir> <subject> 

  Calls LabelOverlapMeasures on each pair of images

  Requires outputDir/subject/subject_WarpedLabels_001.nii.gz etc

  Requires \$ANTSPATH
"
  exit 1
fi

outputDir=$1
subject=$2

if [[ ! -f "${outputDir}/${subject}/${subject}_WarpedLabels_001.nii.gz" ]]; then
  echo "  No data for subject $subject "
  exit 1
fi

binDir=`dirname $0`

submitToQ=1

if [[ ! -f "${ANTSPATH}LabelOverlapMeasures" ]]; then
  echo " Cannot run without ANTSPATH "
  exit 1
fi

if [[ $submitToQ -gt 0 ]]; then
  qsub -S /bin/bash -cwd -j y -o ${outputDir}/${subject}/${subject}_labelOverlap.stdout -q basic.q -v ANTSPATH=$ANTSPATH -l h_vmem=4G,s_vmem=4G ${binDir}/runLabelOverlapMeasures.sh $outputDir $subject
  sleep 0.1
else
  ${binDir}/runLabelOverlapMeasures.sh $outputDir $subject
fi

