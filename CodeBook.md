## Loading and merging data

Data is initially read from the supplied input data set for activity labels, subject labels 

Further, an 'rbind' command is used to join test and train data row-wise.

A grep command is used to extract columns which have mean() or std() substrings. For the given data set this yields 66 columns. Appending activity and subject label columns results in a total of 68 columns.

Iteratively, aggregation is performed across each of the 66 considered columns by activity level and subject.

for (i in 1:length(ind)) {
  avgExtData <- by(newExtData[,i], newExtData[,c(67,68)],mean)
  
  totalAvgData <- cbind(totalAvgData, as.vector(avgExtData))
}


