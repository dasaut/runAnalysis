#
#
# R code submission for the course project of the John Hopkins University "Getting and Cleaning Data" course on Coursera
#
#
#initializing the dplyr package needed for data frame reshaping
library(dplyr)
#
#---------------------------------------------------------------------------------------------------------------------------------
# READING THE RAW DATA FILES for the course project
# (assuming that a directory with the raw data file has been downloaded and copied into the R work directory)
# (further assuming that the structure of the downloaded directory and the the raw data file names are unchanged)
#
# defining a variable that contains the path to the current work directory in R 
workdir <- getwd()
#
#reading the raw data files and saving into the work directory
subjecttest <- read.table(paste(workdir,"/test/subject_test.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
xtest <- read.table(paste(workdir, "/test/X_test.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
ytestraw <- read.table(paste(workdir, "/test/y_test.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
subjecttrain <- read.table(paste(workdir, "/train/subject_train.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
xtrain <- read.table(paste(workdir, "/train/X_train.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
ytrainraw <- read.table(paste(workdir, "/train/y_train.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
#
# reading the variable names from the features.txt file issued by the provider of the raw data
featurenames <- read.table(paste(workdir, "/features.txt", sep=''), header=FALSE, quote="\"", stringsAsFactors=FALSE)
#
#assigning the variable names from the features.txt file to the corresponding variables in the raw data files xtest and xtrain 
names(xtest) <- featurenames$V2
names(xtrain) <- featurenames$V2
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
#replacing the activity factor levels with descriptive activity names by using a lookup table. This is done for both ytest and ytrain raw data files
activitynumber <- c('1', '2', '3', '4', '5', '6')
activitylabel <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING')
lookup <- data.frame(cbind(activitynumber, activitylabel), stringsAsFactors= FALSE)
#
ytest <- ytestraw
for (n in 1:length(ytestraw$V1)) {
ytest[n,1] <- lookup$activitylabel[as.integer(ytestraw[n,1])]  
} 
ytrain <- ytrainraw
for (n in 1:length(ytrainraw$V1)) {
ytrain[n,1] <- lookup$activitylabel[as.integer(ytrainraw[n,1])]  
} 
#
# assigning variable name 'activitylevel' to ytest and ytrain raw data files
names(ytest) <- 'activitylevel'
names(ytrain) <- 'activitylevel'
#
#assigning variable name 'subjectidentifier' to subjecttest and subjecttrain raw data files
names(subjecttest) <- 'subjectidentifier'
names(subjecttrain) <- 'subjectidentifier'
#
# creating two data frames that will be used to indicate which records are from the training and the test group, respectively 
classifiertest <- data.frame(rep('test', times=length(ytestraw$V1)), stringsAsFactors= FALSE)
names(classifiertest) <- 'classifier'
classifiertrain <- data.frame(rep('train', times=length(ytrainraw$V1)), stringsAsFactors= FALSE)
names(classifiertrain) <- 'classifier'
#
#
#--------------------------------------------------------------------------------------------------------------------------------------
#MERGING OF RAW DATA FILES INTO A SINGLE DATA FRAME
#
#merging the test group data 
testdata <- cbind(subjecttest, ytest, xtest, classifiertest)
#
#merging the training group data
traindata <- cbind(subjecttrain, ytrain, xtrain, classifiertrain)
#
#merging the test and training group data frames into one
alldata <- rbind(testdata, traindata)
#
#
#----------------------------------------------------------------------------------------------------------------------------------------
#EXTRACTING ONLY THE COLUNNS CONTAINING MEAN AND STANDARD DEVIATION VALUES
#
#finding variable names with mean values
selectmean <- names(alldata[grepl('mean', names(alldata)) == TRUE])
#finding variable names with std values
selectstd <- names(alldata[grepl('std', names(alldata)) == TRUE])
#combine variable names with mean and std
combinedselect <- c(selectmean, selectstd)
#defining a vector with all variable names used in the tidy data set
allselect <- c('subjectidentifier', 'activitylevel', combinedselect, 'classifier')
#
#creating a data frame with all extracted mean and std columns
selectdata <- alldata[,allselect]
#
#
#----------------------------------------------------------------------------------------------------------------------------------------
#ORDERING AND SUMMARIZING OF THE TIDY DATA FRAME
#
#
arrangedata <- arrange(selectdata, subjectidentifier, activitylevel) 
tidydata <- arrangedata %>%
  group_by(subjectidentifier, activitylevel, classifier) %>%
  summarise_each(funs(mean), 3:82)
#
#optional viewing and writing functions
#View(tidydata)
write.table(tidydata, file='tidydatafile.txt', row.name=FALSE)
#---------------------------------------------------------------------------------------------------------------------------------------
