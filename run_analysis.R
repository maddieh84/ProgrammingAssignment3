library(dplyr)
setwd("/Users/maddiehendrickson/Downloads/")

downloadurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip <- "UCI HAR Dataset.zip"
download.file(downloadurl, zip)

if(file.exists(zip)) unzip(zip)

####
## Files are downloaded and the following files exist
##
main1 <- "UCI HAR Dataset"
featuresfile <- paste(main1, "features.txt", sep="/")
activitylabelsfile <- paste(main1, "activity_labels.txt", sep="/")
testvariablesfile <- paste(main1, "test/X_test.txt", sep="/")
testactivityfile <- paste(main1, "test/y_test.txt", sep="/")
testsubjectfile <- paste(main1, "test/subject_test.txt", sep="/")
trainvariablesfile <- paste(main1, "train/X_train.txt", sep="/")
trainactivityfile <- paste(main1, "train/y_train.txt", sep="/")
trainsubjectfile <- paste(main1, "train/subject_train.txt", sep="/")

need <- c(featuresfile,
                 activitylabelsfile,
                 testvariablesfile,
                 testactivityfile,
                 testsubjectfile,
                 trainvariablesfile,
                 trainactivityfile,
                 trainsubjectfile
)
sapply(need, function(f) if(!file.exists(f)) stop(paste("Needed file ", f, " doesn't exist. Exitting ...", sep="")))

## Read featuresfile
features <- read.table(featuresfile, col.names=c("rownumber","variablename"))
####

####
## Fix the issue with duplicate names (e.g.) 516. fBodyBodyAccJerkMag-mean()
####
allvar <- mutate(features, variablename = gsub("BodyBody", "Body", variablename))

####
## Filtering for mean and standard deviation
####
neededvar <- filter(allvar, grepl("mean\\(\\)|std\\(\\)", variablename))

####
## cleaning all the variables
####
allvar <- mutate(allvar, variablename = gsub("-", "", variablename),
                       variablename = gsub("\\(", "", variablename),
                       variablename = gsub("\\)", "", variablename),
                       variablename = tolower(variablename))

####
## cleaning the needed variables
####
neededvar <- mutate(neededvar, variablename = gsub("-", "", variablename),
                          variablename = gsub("\\(", "", variablename),
                          variablename = gsub("\\)", "", variablename),
                          variablename = tolower(variablename))

####
## Read activitylabelsfile
activitylabels <- read.table(activitylabelsfile, col.names=c("activity", "activitydescription"))
####

####
## Read in test data stats
####
testvalues <- read.table(testvariablesfile, col.names = allvar$variablename)
testneededvalues <- testvalues[ , neededvar$variablename]
####

## Read in test activities
testactivities <- read.table(testactivityfile, col.names=c("activity"))
####

####
## Read in test subjects
testsubjects <- read.table(testsubjectfile, col.names=c("subject"))
####

####
## Add a readable activity description
testactivitieswithdescr <- merge(testactivities, activitylabels)
####

####
## Putting all the test data together
testdata <- cbind(testactivitieswithdescr, testsubjects, testneededvalues)
####

####
## Reading in train variables
####
trainvalues <- read.table(trainvariablesfile, col.names = allvar$variablename)
trainneededvalues <- trainvalues[ , neededvar$variablename]
####

## Read in train activities
trainactivities <- read.table(trainactivityfile, col.names=c("activity"))
####

####
## Read in train subjects
trainsubjects <- read.table(trainsubjectfile, col.names=c("subject"))
####

####
## Add a readable activity description
trainactivitieswithdescr <- merge(trainactivities, activitylabels)
####

####
## Putting train data all together
traindata <- cbind(trainactivitieswithdescr, trainsubjects, trainneededvalues)
####


