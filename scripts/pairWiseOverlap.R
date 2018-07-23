
## Reads label overlap files from experiment/output
##
## The output from this can be passed to getROIOverlaps
##
reaPairwiseLabelOverlaps <- function(experiment) {

  subjects = list.files(paste(experiment, "output", sep = "/"))
  
  numSubjects = length(subjects)
  
  ## labelOverlapMeasures[[subject]][[1-numRuns]] is a data frame with label overlaps
  labelOverlapMeasures = list()

  labelOverlapFiles = list()
  
  for (s in 1:numSubjects) {

    subj = subjects[s]
    
    labelOverlapMeasures[[subj]] = list()

    overlapFilesSubj = list.files(paste(experiment, "output", subj, sep = "/"), "PairwiseLabelOverlap", full.names = T)

    numPairs = length(overlapFilesSubj)
    
    for (p in 1:numPairs) {
      labelOverlapMeasures[[s]][[p]] = read.csv(overlapFilesSubj[p])
    }

    labelOverlapFiles[[s]] = overlapFilesSubj
    
  }
  return(list(subjects = subjects, labelOverlaps = labelOverlapMeasures, labelOverlapFiles = labelOverlapFiles, experiment = experiment))
  
}

##
## getROIOverlaps(labelOverlaps, subjectIDs, labelID, labelDisplayName, measure = "Dice")
##
##   labelOverlaps[[s]][[r]] contains matrix for subject s run r
##
##   subjectIDs - character vector for plotting, one label per subject 
##
##   labelID - the label to extract overlaps for.
##
##   labelDisplayName - for plotting titles, eg "Cerebral White Matter R"
##
##   measure - "Dice", "Jaccard", or other output from ANTs LabelOverlapMeasures (case sensitive)
##
##   returns a list of the label overlaps extracted, and other relevant info
##
getROIOverlaps <- function(labelOverlaps, subjectIDs, labelID, labelDisplayName, measure = "Dice", plot = F) {


  numSubjects = length(labelOverlaps)

  if (length(subjectIDs) != numSubjects) {
    stop("List of subject IDs is not the same length as list of overlaps")
  }
  
  numTests = length(labelOverlaps[[1]])
  
  roiOverlap = list()

  ## Careful as label position may switch rarely, but column output is fixed
  cols = c("Total/Target","Jaccard","Dice","VolumeSimilarity","FalseNegative","FalsePositive")
  
  whichCol = 0
  
  for (i in 1:length(cols)) {
    if (cols[i] == measure) {
      whichCol = i + 1 ## +1 needed because first column is label ID
    }
  }
  
  if (whichCol == 0) {
    stop(paste("Unrecognized overlap measure", measure))
  }

  
  for (s in 1:numSubjects) {
    
    roiSubjectOverlap = vector("numeric", length = numTests);
    
  
    for (i in 1:numTests) {
      roiSubjectOverlap[i] = labelOverlaps[[s]][[i]][which(labelOverlaps[[s]][[i]]$Label == labelID), whichCol]
    }

    roiOverlap[[s]] = roiSubjectOverlap
    
  }

  return(list(roiOverlap = roiOverlap, subjectIDs = subjectIDs, labelID = labelID, labelName = labelDisplayName, measure = measure))
  
}
