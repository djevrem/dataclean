## Loading and merging data

Data is initially read from the supplied input data set for activity labels, subject labels 

Further, an 'rbind' command is used to join test and train data row-wise.

A grep command is used to extract columns which have mean() or std() substrings. For the given data set this yields 66 columns. Appending activity and subject label columns results in a total of 68 columns.


## Computation of mean values for mean() and std() columns

Iteratively, aggregation is performed across each of the 66 considered columns by activity level and subject.

```
for (i in 1:length(ind)) {
  avgExtData <- by(newExtData[,i], newExtData[,c(67,68)],mean)
  
  totalAvgData <- cbind(totalAvgData, as.vector(avgExtData))
}
```

Further, the descriptive names are assigned to all columns, and the activity level identifiers are replaced with their actual names.

```
#create a data frame, and assign descriptive names to columns
finalAvgData <- data.frame(totalAvgData)
colnames(finalAvgData)[1:length(ind)] <- as.character(features[ind,2])
colnames(finalAvgData)[c(67,68)] <-c("activity","subject")

# assign acitvity names to the "activity" column instead of numerical values
finalAvgData[,"activity"] <- activityLabels[finalAvgData[,"activity"],2]
```


