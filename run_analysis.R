##################################################################################################
# run_analysis.R
#
# This is the course project for _Getting and Cleaning Data_, part of Coursera's and John Hopkin's
# data science track.
#
# There are five tasks to complete to pass this project:
#   * Merges the training and the test sets to create one data set.
#   * Extracts only the measurements on the mean and standard deviation for each measurement. 
#   * Uses descriptive activity names to name the activities in the data set
#   * Appropriately labels the data set with descriptive variable names. 
#   * Creates a second, independent tidy data set with the average of each variable for each
#     activity and each subject. 

# Task 0: download and unzip the files.
# This task is currently commented out so that it doesn't download and unzip everything over 
# and over again (bandwidth is limited where I'm writing this.
#if (!file.exists("./data")) {dir.create("./data")}
#fileURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL, destfile = "./data/dataset.zip", method = "curl", mode = "wb")
#unzip("./data/dataset.zip")

# Task 1: Merge training and test sets to create one data set.
# Task 2: Extract only the measurements on the mean and standard deviation for each measurement.
# Task 4: Appropriately labels the data set with descriptive variable names.
## Start by reading in all six files
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE, sep = ",", col.names = "Subject", colClasses = "integer")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE, sep = ",", col.names = "Subject", colClasses = "integer")
testY <- read.table("./UCI HAR Dataset/test/Y_test.txt", header = FALSE, sep = ",", col.names = "Activities", colClasses = "integer")
trainY <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = FALSE, sep = ",", col.names = "Activities", colClasses = "integer")
XNames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, sep = "")
testX <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE, sep = "", strip.white = TRUE, col.names = XNames[, 2])
trainX <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE, sep = "", strip.white = TRUE, col.names = XNames[, 2])
## keep only columns with "mean", "Mean", "std", or "Std" in their names
testX <- testX[, grepl("Mean", XNames[,2]) | grepl("mean", XNames[,2]) | grepl("Std", XNames[,2]) | grepl("std", XNames[,2])]
trainX <- trainX[, grepl("Mean", XNames[,2]) | grepl("mean", XNames[,2]) | grepl("Std", XNames[,2]) | grepl("std", XNames[,2])]
## concatenate the test and training data files into single files
testData <- cbind(testSubject, testY, "TestOrTrain" = c("Test"), testX)
trainData <- cbind(trainSubject, trainY, "TestOrTrain" = c("Train"), trainX)
## and combine the two datasets into a single one
allData <- rbind(testData, trainData)

# Task 3: Use descriptive activity names to name the activities in the data set
allData <- cbind(allData[,c(1,2)], "ActivityName" = "", allData[,c(3: )])
allData$ActivityName <- ActivityLables[allData$Activities, 2]

# Task 5: Create a second, independent tidy data set with the average of each variable for each
#     activity and each subject.
tidyData <- data.frame()  # create empty data frame for the tidy data
for (i in allData$Subject)
  for (j in allData$ActivityName) {
    tempRow <- rbind("Subject" = i, "ActivityName" = j, colMeans(allData[allData$Subject == i & allData$ActivityName == j, c(5:90)]))
    tidyData <- rbind(tidyData, tempRow) 
  }