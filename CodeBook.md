## Loading and merging input data

Data is initially read from the supplied input data set for activity labels, subject labels 
```
#read activity labels
activityLabels <- read.table("har\\activity_labels.txt")

#read the test and training attribute data
testData <- read.table("har\\test\\X_test.txt")
testActivityLabel <- read.table("har\\test\\y_test.txt")
testSubject <- read.table("har\\test\\subject_test.txt")
testData <- cbind(testData, testActivityLabel, testSubject)

trainData <- read.table("har\\train\\X_train.txt")
trainActivityLabel <- read.table("har\\train\\y_train.txt")
trainSubject <- read.table("har\\train\\subject_train.txt")
trainData <- cbind(trainData, trainActivityLabel, trainSubject)
```

##Merging training and test data

Further, an 'rbind' command is used to join test and train data row-wise.
```
#merge them into one data set
newData<-rbind(testData,trainData)
```

A grep command is used to extract columns which have mean() or std() substrings. For the given data set this yields 66 columns. Appending activity and subject label columns results in a total of 68 columns.
```
#read features and their names from the file
features <- read.table("har\\features.txt")

#extract those fearures which refer to mean and standard deviation
indStd <- grep("std\\(\\)",features[,2])
indMean <- grep("mean\\(\\)",features[,2])
ind <- c(indStd, indMean)
```

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

##Saving result to output file

Finally, the data frame is saved as 180 x 68 table into a text file as

```
#save the final tidy data set to file
write.table(finalAvgData,file="myTidySet.txt")
```


