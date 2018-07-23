#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "  $0 <subject> <iterationNumber> <cores> 

  Iteration number is used as a string (should be pre-formatted)

  Specify cores > 1 to test multiple-threads

  Warps are written to \$TMPDIR, deformed gray image and label image is retained

  Requires \$ANTSPATH

"
  exit 1
fi

subject=$1
iterationNumber=$2
cores=$3

export ANTS_RANDOM_SEED=390772

fixed="data/template/T_template0_BrainCerebellum.nii.gz"
moving="data/Brains/${subject}_3.nii.gz"
labels="data/Segmentations/${subject}_3_seg.nii.gz"

regOutputRoot="${TMPDIR}/${subject}_ToTemplate_${iterationNumber}_"

regCmd="${ANTSPATH}antsRegistrationSyNQuick.sh -d 3 -f $fixed -m $moving -t s -p f -n $cores -o $regOutputRoot"

echo "
--- Running on $HOSTNAME ---
"

echo "
--- registration call ---
$regCmd
---
"

$regCmd

outputGrayWarped="output/${subject}/${subject}_WarpedGray_${iterationNumber}.nii.gz"
outputLabelsWarped="output/${subject}/${subject}_WarpedLabels_${iterationNumber}.nii.gz"

echo "
--- Writing output images ---
"

# We retain warped grayscale images and labels
cp ${regOutputRoot}Warped.nii.gz $outputGrayWarped

${ANTSPATH}antsApplyTransforms -d 3 -i $labels -o $outputLabelsWarped -t ${regOutputRoot}1Warp.nii.gz -t ${regOutputRoot}0GenericAffine.mat -r $fixed -n GenericLabel --verbose

echo "
--- Done ---
"
