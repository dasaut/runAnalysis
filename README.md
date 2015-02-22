# File name:  run_analysis.R

#Purpose:
R code submitted for the course project of the John Hopkins University "Getting and Cleaning Data" course on Coursera




#Requirements:

 1) a directory with the raw data file has been downloaded and copied into the current R work directory

2) the structure of the downloaded directory and the the raw data file names are unchanged

#What the code does:

1) READING DATA from THE RAW DATA FILES by
- defining a variable that contains the path to the current work directory in R
- initializing the dplyr package needed for data frame reshaping
- reading the raw data files and saving into the work directory
- reading the variable names from the features.txt file issued by the provider of the raw data
- assigning the variable names from the features.txt file to the corresponding variables in the raw data files xtest and xtrain

2) replacing the activity factor levels with descriptive activity names by using a lookup table. This is done for both ytest and ytrain raw data files

- assigning variable name 'activitylevel' to ytest and ytrain raw data files
- assigning variable name 'subjectidentifier' to subjecttest and subjecttrain raw data files
- creating two data frames that will be used to indicate which records are from the training and the test group, respectively

3) MERGING OF RAW DATA FILES INTO A SINGLE DATA FRAME
- merging the test group data
- merging the training group data
- merging the test and training group data frames into one

4) EXTRACTING ONLY THE COLUNNS CONTAINING MEAN AND STANDARD DEVIATION VALUES
- finding variable names with mean values
- finding variable names with std values
- combine variable names with mean and std
- defining a vector with all variable names used in the tidy data set
- creating a data frame with all extracted mean and std columns

5) ORDERING AND SUMMARIZING OF THE TIDY DATA FRAME
- grouping of the data by Subject ID, activity level, group (test and training group)
- calculating the mean of all variables for each group
