# GCD_Project
CODE BOOK

The tidy data set described below is derived from the Human Activity Recognition Using Smartphones Dataset (Version 1.0).  
The original data files represent experiments carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing 
a smartphone (Samsung Galaxy S II) on the waist.  Using its embedded accelerometer and gyroscope, the experiment captured
3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded 
to label the data manually.  The obtained dataset was then randomly partitioned into two sets, where 70% of the volunteers 
was selected for generating the training data and 30% the test data. A fuller description of the original data is available
at the link below:
  - http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The specific data files used for this project are available at this link: 
  - https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script reads in the relevant data files list below;  merges the training and test data sets; 
extracts the measurements on the mean and standard deviation for each featured measurement (listed in the features.txt file); and finally creates an independent tidy data set with the average of each measured variable from the combined training and test sets for each activity and each subject.  The tidy_data.txt file meets parameters of a tidy data set with one variable per column and one observation per row.  The run_analysis.R script is listed below, after the Data Dictionary.

Original dataset files:
  - 'features.txt': List of all featured measurements.  Additional information available in features_info.txt.
  - 'activity_labels.txt': Links the class labels with their activity name.
    - 1 WALKING
    - 2 WALKING_UPSTAIRS
    - 3 WALKING_DOWNSTAIRS
    - 4 SITTING
    - 5 STANDING
    - 6 LAYING
  - 'train/X_train.txt': Training set.
  - 'train/y_train.txt': Training labels - intergers from 1 to 6 matching activity_labels factors 
  - 'test/X_test.txt': Test set.
  - 'test/y_test.txt': Test labels - intergers from 1 to 6 matching activity_labels factors
  - 'train/subject_train.txt': One row per subject who performed the activity for each window sample - integers from 1 to 30. 
  - 'test/subject_test.txt': One row per subject who performed the activity for each window sample - integers from 1 to 30 

Data Dictionary for tidy_data.txt file:
  - Subject: integers from 1 to 30
  - Activity: factors 
    - 1 WALKING
    - 2 WALKING_UPSTAIRS
    - 3 WALKING_DOWNSTAIRS
    - 4 SITTING
    - 5 STANDING
    - 6 LAYING
  - Variables for the mean and standard deviation for each featured measurement.  Note( the chars '-','('. and ')' in original variable names were replaced with '.':
    - tBodyAcc.mean...X
    - tBodyAcc.mean...Y
    - tBodyAcc.mean...Z
    - tGravityAcc.mean...X
    - tGravityAcc.mean...Y
    - GravityAcc.mean...Z
    - tBodyAccJerk.mean...X
    - tBodyAccJerk.mean...Y
    - tBodyAccJerk.mean...Z
    - tBodyGyro.mean...X
    - tBodyGyro.mean...Y
    - tBodyGyro.mean...Z
    - tBodyGyroJerk.mean...X
    - tBodyGyroJerk.mean...Y
    - tBodyGyroJerk.mean...Z
    - tBodyAccMag.mean..
    - tGravityAccMag.mean..
    - tBodyAccJerkMag.mean..
    - tBodyGyroMag.mean..
    - tBodyGyroJerkMag.mean..
    - fBodyAcc.mean...X
    - fBodyAcc.mean...Y
    - fBodyAcc.mean...Z
    - fBodyAccJerk.mean...X
    - fBodyAccJerk.mean...Y
    - fBodyAccJerk.mean...Z
    - fBodyGyro.mean...X
    - fBodyGyro.mean...Y
    - fBodyGyro.mean...Z
    - fBodyAccMag.mean..
    - fBodyBodyAccJerkMag.mean..
    - fBodyBodyGyroMag.mean.. 
    - fBodyBodyGyroJerkMag.mean.. 
    - tBodyAcc.std...X 
    - tBodyAcc.std...Y 
    - tBodyAcc.std...Z 
    - tGravityAcc.std...X 
    - tGravityAcc.std...Y 
    - tGravityAcc.std...Z 
    - tBodyAccJerk.std...X 
    - tBodyAccJerk.std...Y 
    - tBodyAccJerk.std...Z 
    - tBodyGyro.std...X 
    - tBodyGyro.std...Y 
    - tBodyGyro.std...Z 
    - tBodyGyroJerk.std...X 
    - tBodyGyroJerk.std...Y 
    - tBodyGyroJerk.std...Z 
    - tBodyAccMag.std.. 
    - tGravityAccMag.std.. 
    - tBodyAccJerkMag.std.. 
    - tBodyGyroMag.std.. 
    - tBodyGyroJerkMag.std.. 
    - fBodyAcc.std...X 
    - fBodyAcc.std...Y 
    - fBodyAcc.std...Z 
    - fBodyAccJerk.std...X 
    - fBodyAccJerk.std...Y 
    - fBodyAccJerk.std...Z 
    - fBodyGyro.std...X 
    - fBodyGyro.std...Y 
    - fBodyGyro.std...Z 
    - fBodyAccMag.std.. 
    - fBodyBodyAccJerkMag.std.. 
    - fBodyBodyGyroMag.std.. 
    - fBodyBodyGyroJerkMag.std..
  
R Script file (r_analysis.R):

    ## Requires packages, install if necessary
    ## install.packages("plyr");install.packages("dplyr"); install.packages("reshape2")
    ## library(plyr); library(dplyr);library("reshape2")
  
    ## Activity factor labels, and measured features for both training and test sets.
    aclabel <- read.table("./activity_labels.txt", header=FALSE, sep="", col.names=c("level","label"))
    features <- read.table("./features.txt", header=FALSE, sep="",  col.names=c("index","varnames"))
    
    ## Merge test and training data tables
    xtest <- read.table("./test/X_test.txt", sep="", header=FALSE, col.names=features$varnames) 
    xtrain <- read.table("./train/X_train.txt", sep="", header=FALSE, col.names=features$varnames)
    alldata <- rbind(xtest,xtrain)
    rm(xtest); rm(xtrain)
    
    ## Extract mean and std measurements  
    mean <-select(alldata, contains(".mean.."))
    std <-select(alldata, contains(".std.."))
    mean_std <- cbind(mean,std)  
    rm(alldata);rm(mean);rm(std)
  
    ## Add activity variable for measurements - match order for rbind(xtest,xtrain)
    ytest <- read.table("./test/y_test.txt", header=FALSE, sep="",  col.names=c("activity"))
    ytrain <- read.table("./train/y_train.txt", header=FALSE, sep="",  col.names=c("activity"))
    allacts <- rbind(ytest, ytrain)
    mean_std <- cbind(allacts, mean_std)
    rm(ytest);rm(ytrain);rm(allacts)
  
    ## Add subject & measurements - match order for rbind(xtest,xtrain)
    subtest <- read.table("./test/subject_test.txt", sep="", header=FALSE, col.names=c("subject"))  
    subtrain <- read.table("./train/subject_train.txt", sep="", header=FALSE, col.names=c("subject"))
    allsubjects <- rbind(subtest,subtrain)
    mean_std <- cbind(allsubjects, mean_std)
    rm(subtest);rm(subtrain);rm(allsubjects);
  
    ## Order by subject and activities
    mean_std <- mean_std[order(mean_std$subject, mean_std$activity),]
  
    ## Set vars for creating tidy data set
    numCols = ncol(mean_std)
    varNames <- colnames(mean_std) 
    sub_acts <- mean_std[,1:2]
    tidyData <- unique(sub_acts)
  
    for (i in 3:68) {
      df <- cbind(sub_acts, mean_std[,i])
      names(df)[3] <- "V3"
      temp <- ddply(df, .(activity, subject), summarize, ave=ave(V3))
      temp <- unique(temp)
      tidyData <- cbind(tidyData, temp$ave)
      names(tidyData)[i] <- varNames[i]               
    }
    tidyData$activity = factor(tidyData$activity, levels=aclabel$level, labels=aclabel$label)
    write.table(tidyData, file = "tidy_data.txt", row.names = FALSE)
 






