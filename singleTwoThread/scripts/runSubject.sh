#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo " $0 <subject> 

  Requires data/Brains/subject_3.nii.gz and data/Segmentations/subject_3_seg.nii.gz

  Creates output/subject

  Requires \$ANTSPATH
"
  exit 1
fi

subject=$1

if [[ ! -f "data/Brains/${subject}_3.nii.gz" ]]; then
  echo "  No data for subject $subject "
  exit 1
fi

binDir=`dirname $0`

its=25

submitToQ=1

cores=2

if [[ ! -f "${ANTSPATH}antsRegistrationSyNQuick.sh" ]]; then
  echo " Cannot run without ANTSPATH and antsRegistrationSyNQuick.sh script "
  exit 1
fi

mkdir -p output/$subject

for i in `seq -w 001 0${its}`; do 

  if [[ $submitToQ -gt 0 ]]; then
    # restrict to basic.q for same hardware
    qsub -S /bin/bash -cwd -j y -o output/${subject}/${subject}_reg_${i}.stdout -q basic.q -v ANTSPATH=$ANTSPATH -l h_vmem=4G,s_vmem=4G ${binDir}/runRegDeformLabels.sh $subject $i $cores
    sleep 0.1
  else
    ## Qlogin or qsub this script with multiple cores in order to use this
    ## This option runs each iteration on the same machine
    ${binDir}/runRegDeformLabels.sh $subject $i $cores
  fi

done
