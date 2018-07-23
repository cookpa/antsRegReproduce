source("scripts/pairWiseOverlap.R")
library(knitr)

experiments = c("doubleOneThread", "doubleOneThreadFixSeed", "doubleTwoThreadFixSeed", "singleOneThread", "singleOneThreadFixSeed", "singleTwoThread")

for (counter in 1:length(experiments)) {
  
  pairwiseOverlaps = readPairwiseLabelOverlaps(experiments[counter])
  
  wmLeft = getROIOverlaps(pairwiseOverlaps$labelOverlaps, pairwiseOverlaps$subjects, 45, "Cerebral WM Left")
  wmRight = getROIOverlaps(pairwiseOverlaps$labelOverlaps, pairwiseOverlaps$subjects, 44, "Cerebral WM Right")

  numSubjects = length(pairwiseOverlaps$subjects)

  wmOverlap = list()
  
  for (subj in 1:numSubjects) {
    wmOverlap[[subj]] = c(wmLeft$roiOverlap[[subj]], wmRight$roiOverlap[[subj]])
  }

  # x11()
  # dumps PDFs to cwd
  pdf(paste(experiments[counter], ".pdf", sep = ""))
  boxplot(wmOverlap, names = wmLeft$subjectIDs, main = paste("WM overlap ", experiments[counter], sep = ""), ylab = "Dice", xlab = "Subject", ylim = c(0.9,1))
  dev.off()

  # print means and SDs
  tableData = data.frame(Subject = as.character(subjects), meanDice = as.numeric(unlist(lapply(wmOverlap, mean))), ci95 = as.numeric(unlist(lapply(wmOverlap, sd)) * 1.96), stringsAsFactors = F)

  tableData = rbind(tableData, list("Group", mean(tableData$meanDice), mean(tableData$ci95)))

  print(experiments[counter])
  
  print(kable(tableData, digits = 3))

}


