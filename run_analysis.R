# the URL of file to download
theURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# name of destination file
destfile <- "wearComp.zip"

# command to download zip file from internet to destination file on local computer
download.file(theURL, destfile)

# unzip downloaded zip file
unzip(destfile)

# sets working directory to unzipped folder
setwd("./UCI HAR Dataset")

# reads features.txt file from UCI HAR Dataset directory
# contains labels of 561 measurement variables
features <- scan(file="features.txt", what=character(), sep="\n")

# set working directory to test directory within previous directory
setwd("./test")

# read all three text files in test directory: subjects, data, & activities
test_files <- list.files()[-1]
test_data <- lapply(test_files, scan)

# change working directory to train directory
setwd("../train")

# read all three text files in train directory: subjects, data, & activities
train_files <- list.files()[-1]
train_data <- lapply(train_files, scan)

# finds vector position of all feature variables with mean in variable label
mean_df_columns <- grep("mean", features, ignore.case=TRUE)

# finds vector position of all feature variables with std in variable label
std_df_columns <- grep("std", features, ignore.case=TRUE)

# tidy up features variables: first extract out means and standard deviation columns
features <- features[c(mean_df_columns, std_df_columns)]

# second, string split and remove the numbers from label columns
features <- strsplit(features, split=" ")
features <- lapply(features, function(x) x <- x[2])

# third, replace all shortnames with their respective longnames
features <- lapply(features, function(x) gsub("Gyro", "Gryoscope", x))
features <- lapply(features, function(x) gsub("Acc","Accelerometer", x)) 
features <- lapply(features, function(x) gsub("-mean()", " Mean", x))
features <- lapply(features, function(x) gsub("-std()", " Standard Deviation", x))
features <- unlist(features)

# replace activity nominal numbers by activity names by
# first combining nominal activity numbers from test and train sets
act_nominals <- c(test_data[[3]], train_data[[3]])

# second, reading in activity labels corresponding to nominal numbers
activity_labels <- scan("../activity_labels.txt", character(), sep="\n")

# following two lines tidy up activity labels by
# splitting string and removing front number from activity label 
activity_labels <- lapply(activity_labels, function(x) x <- strsplit(x, split=" "))
activity_labels <- lapply(activity_labels, function(x) x <- unlist(x)[-1])

# substitute activity nominal numbers by corresponding descriptive label words
activity_labels <- list(unlist(lapply(act_nominals, function(x) x <- activity_labels[x])))

# list with one component: all test and train subjects represented nominally
subjects_all <- list(c(test_data[[1]], train_data[[1]]))

# created matrix by row with test set, & train set;
# and extracted out mean and standard deviation columns and reconverted to data frame
df_Sets <- as.data.frame(matrix(c(test_data[[2]], train_data[[2]]), ncol=561, byrow=TRUE)[,c(mean_df_columns, std_df_columns)])

# names previous data frame with corresponding feature variable class labels 
names(df_Sets) <- features

# constructs last piece of the data frame corresponding to columns
# subjects and activities
df_subj_act <- data.frame(subjects_all, activity_labels)

# name the previous data frame columns: Subjects and Activities
names(df_subj_act) <- c("Subjects", "Activities") 

# combines both pieces of previous data frames to complete the tidy data frame
df_to_Pt4 <- data.frame(df_subj_act, df_Sets)

# Step 5:
# library needed to use melt and dcast functions to reshape data
library(reshape2)

# creates a list of melted data frames: each data frame in list has 
# Subjects and Activities with one corresponding feature variable
ls_of_melts <- lapply(3:88, function(x) melt(df_to_Pt4, id.vars=c("Subjects","Activities"), measure.vars=x, variable.name="Feature.Variable", value.name="Feature.Values"))

# recast all data frames in list by taking mean with respect to subject and 
# activity of each feature variable
ls_of_dcast <- lapply(ls_of_melts, function(x) dcast(x, Subjects~Activities, mean))

# melts again each data frame in list so that subject and activity are side by side 
# with corresponding average of feature variable
ls_of_melts2 <- lapply(ls_of_dcast, function(x) melt(x, id.vars="Subjects", variable.name="Activities"))

# extracts subject and activities columns
df_final1 <- ls_of_melts2[[1]][c(1,2)]

# extracts each feature variable from each data frame in list
df_final2 <- lapply(ls_of_melts2, function(x) x <- as.data.frame(x[c(-1,-2)]))

# reassembles parts into one final data frame i.e. all averages of feature variables
# corresponding to subject and activity
df_Final <- data.frame(df_final1, df_final2)

# puts back the names into final data frame
names(df_Final)[3:88] <- names(df_to_Pt4[,3:88])

# writes data frame into text file 
write.table(df_Final, "../df_Final.txt", sep=",")