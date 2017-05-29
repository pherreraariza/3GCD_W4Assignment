library(dplyr)

setwd("/Users/pherreraariza/Documents/Coursera/3_Getting_and_Cleaning_Data/3GCD_W4Assignment/")


## Download the file and put the file in the data folder

if(!file.exists("./data")) {
                dir.create("./data")
                fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
                download.file(fileUrl, destfile="./data/UCI HAR Dataset.zip", method="curl")
                unzip(zipfile="./data/UCI HAR Dataset.zip", exdir="./data")}

## Unzipped files are in the folder UCI HAR Dataset. Get the list of the files

path_data <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_data, recursive=TRUE)

## Read activity files

dataActivityTest  <- read.table(file.path(path_data, "test" , "Y_test.txt" ), header = FALSE)
dataActivityTrain <- read.table(file.path(path_data, "train", "Y_train.txt"), header = FALSE)

## Read the Subject files

dataSubjectTrain <- read.table(file.path(path_data, "train", "subject_train.txt"), header = FALSE)
dataSubjectTest  <- read.table(file.path(path_data, "test" , "subject_test.txt"), header = FALSE)

## Read Fearures files

dataFeaturesTest  <- read.table(file.path(path_data, "test" , "X_test.txt" ), header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_data, "train", "X_train.txt"), header = FALSE)

## Merge the test and traning datasets

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## Set names to variables

names(dataSubject) <- "subject"
names(dataActivity) <- "activityId"
dataFeaturesNames <- read.table(file.path(path_data, "features.txt"), head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## Merge columns to get dataframe for all data

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## Subset Name of Features by measurements on the mean and standard deviation

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## Subset the data frame Data by selected names of Features

selectedNames <- c(as.character(subdataFeaturesNames), "subject", "activityId" )
Data <- subset(Data,select=selectedNames)

## Read descriptive activity names from “activity_labels.txt”

activityLabels <- read.table(file.path(path_data, "activity_labels.txt"),header = FALSE)
colnames(activityLabels) <- c("activityId", "activity")
Data <-  merge(Data, activityLabels, by='activityId', all.x=TRUE)
Data <- Data[, -1]

names(Data) <- gsub("^t", "time", names(Data))
names(Data) <- gsub("^f", "frequency", names(Data))
names(Data) <- gsub("Acc", "Accelerometer", names(Data))
names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))

## Creates a second,independent tidy data set and ouput it

Data2 <- aggregate(. ~ subject + activity, Data, mean)
Data2 <- Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt", row.name=FALSE)

