  ## Requires packages, intall if necessary
  ##install.packages("plyr");install.packages("dplyr"); install.packages("reshape2")
  #library(plyr); library(dplyr);library("reshape2")

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
