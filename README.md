# antsRegReproduce

Reproducibility experiments for antsRegistration


## Data

Data is 10 subjects from the MICCAI 2012 segmentation challenge:

1002 
1005 
1008 
1011 
1014 
1018 
1101 
1110 
1119 
1128

The template is available from 

  https://figshare.com/articles/ANTs_ANTsR_Brain_Templates/915436


Before running experiments, you will need to populate the data directory, 
which contains:

  data/
       Brains/
       Segmentations/
       template/

Brains/ should contain the brain images, skull removed, named ${subject}_3.nii.gz.
If you do not have these already, you will need to create them by binarizing the 
segmentations and then masking the head images.

Segmentations/ should contain the segmentation images, named ${subject}_3_seg.nii.gz. 
The label definitions are provided in docs/labelDefinitions.csv.

template/ should contain the contents of the OASIS template zip file from Figshare.


## Experiments

Each experiment is self contained with a directory structure:

  data/
  output/
  scripts/

For the pre-computed results in this repository, the data directory was a
symbolic link to the top-level data directory.

Each experiment has its own set of scripts to call antsRegistration. The wrappers
call SGE qsub and will probably need to be modified for your cluster environment.


## Scripts for collating output.

Scripts for computing label overlap and extracting the results for a particular ROI 
are in the top-level scripts/ directory.



