 # read Training sets
   trainX <- read.table("./train/X_train.txt")
   trainy <- read.table("./train/y_train.txt")
   trainsubj <- read.table("./train/subject_train.txt")
 
 # read Test sets 
   testX <- read.table("./test/X_test.txt")
   testy <- read.table("./test/y_test.txt")
   testsubj <- read.table("./test/subject_test.txt")

 # merge Test and Training sets 
   mergeX <- rbind(testX,trainX)
   mergey <- rbind(testy,trainy)
   
 # rename the training data column to 'activity'
   colnames(mergey) <- "activity"
 
 # read features.txt data
   feature <- read.table("./features.txt")
 
   names(mergeX) <- feature$V2
 
 # merge subject test and training data
   mergeSubj <- rbind(testsubj,trainsubj)
 # rename subject data column to "subject"
   colnames(mergeSubj) <- "subject"

 # Read Activity.txt data
   activitydata <- read.table("./activity_labels.txt")
 # Remove '_' from the activity description column and convert to lower case
   activitydata[,"V2"] <- gsub("_","",tolower(activitydata$V2))
 # Rename the columns in the activity data
   colnames(activitydata)[1] <-"activity"
   colnames(activitydata)[2] <-"description"
 
 # merge activity labels; Uses descriptive activity names to name the activities in the data set
   activitylbl <- merge(mergey,activitydata,by="activity")
 
 # merges the training and the test sets to create one data set.
   Dataset <- cbind(mergeX,activitylbl[["description"]],mergeSubj)
   colnames(Dataset)[562] = "ActivityName"
 
 # extract Mean and Standard Deviation data from Features.txt
   measureextract <- grep(".*[Mm]ean\\(\\)|.*[Ss]td\\(\\)",feature$V2)
 # Appropriately labels the data set with descriptive activity names 
   cleaddata <- Dataset[, c(measureextract,562,563)]
 # Remove '()' from the dataset measurements  
   names(cleandata) <- gsub("\\(|\\)","",names(cleandata))
 
 # Creates a second, independent tidy data set with the average of each variable 
 # for each activity and each subject. 
   
   tidydata <- data.table(cleandata)
   averagedata <-  tidydata[, lapply(.SD, mean), by=c("subject", "activityName")]
 # Orders the dataset of the average by the activity 
   averagedata <- averagedata[order(averagedata$activityName,]

 # Exporting data into a .txt file:
   write.table(averagedata, "tidydata.txt",sep='\t')
