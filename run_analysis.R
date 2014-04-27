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

#merge them into one data set
newData<-rbind(testData,trainData)

#read features and their names from the file
features <- read.table("har\\features.txt")

#extract those fearures which refer to mean and standard deviation
indStd <- grep("std\\(\\)",features[,2])
indMean <- grep("mean\\(\\)",features[,2])
ind <- c(indStd, indMean)

#now subset the data set according to extracted columns
newExtData <- newData[,c(ind, 562, 563)]

#initialize the array which will hold summary data for every pair (activity, subject)
totalAvgData <- c()

#iterate over the selected mean or std features, and for every pair (activity,subject) compute the mean
for (i in 1:length(ind)) {
  avgExtData <- by(newExtData[,i], newExtData[,c(67,68)],mean)
  
  #append the means for the current feature to to matrix column wise
  totalAvgData <- cbind(totalAvgData, as.vector(avgExtData))
}

#add the activity and subject columns to the right of the matrix/array
totalAvgData <- cbind(totalAvgData, activityLabels[rep(1:6,30),2], rep(1:30, each=6))


#create a data frame, and assign descriptive names to columns
finalAvgData <- data.frame(totalAvgData)
colnames(finalAvgData)[1:length(ind)] <- as.character(features[ind,2])
colnames(finalAvgData)[c(67,68)] <-c("activity","subject")

# assign acitvity names to the "activity" column instead of numerical values
finalAvgData[,"activity"] <- activityLabels[finalAvgData[,"activity"],2] 

#save the final tidy data set to file
write.table(finalAvgData,file="myTidySet.txt")
