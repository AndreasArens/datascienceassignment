## run_analysis.R

# 0. load data
activity_labels <- read.table('data/UCI HAR Dataset/activity_labels.txt', header=FALSE, col.names=c('activity_id', 'activity_label'));
features <- read.table('data/UCI HAR Dataset/features.txt', header=FALSE, col.names=c('feature_id', 'feature_name'));
dim(features)
subject_train <- read.table('data/UCI HAR Dataset/train/subject_train.txt', header=FALSE, col.names=c('subject_id'))
dim(subject_train)
X_train <- read.table('data/UCI HAR Dataset/train/X_train.txt', header=FALSE, col.names=features[,2])
dim(X_train)
y_train <- read.table('data/UCI HAR Dataset/train/y_train.txt', header=FALSE, col.names=c('activity_id'))
dim(y_train)

subject_test <- read.table('data/UCI HAR Dataset/test/subject_test.txt', header=FALSE, col.names=c('subject_id'))
dim(subject_test)
X_test <- read.table('data/UCI HAR Dataset/test/X_test.txt', header=FALSE, col.names=features[,2])
dim(X_test)
y_test <- read.table('data/UCI HAR Dataset/test/y_test.txt', header=FALSE, col.names=c('activity_id'))
dim(y_test)

# after loading the basic files and investigating with dim(), we have the following data available:
# - activity_labels:    6x2         (activity_id, activity_name)
# - features:           561x2       (feature_id, feature_name)
# - subject_train:      7352x1      (subject_id)
# - X_train:            7352x561    ("features")
# - y_train:            7352x1      (activity_id)
# - subject_test:       2947x1      (subject_id)
# - X_test:             2947x561    ("features")
# - y_test:             2947x1      (activity_id)

# 1. Merge the training and the test sets to create one data set.

# Step 1.1: join the training data sets 
training_data <- cbind(X_train, y_train, subject_train)
# Step 1.2: join the test data sets 
test_data <- cbind(X_test, y_test, subject_test)

# Step 1.3: both training and test data have same width (# columns); join them
complete_data <- rbind(training_data, test_data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement. 

## according to the file 'features_info', variables that represent mean values have the string 'mean()' appended
## to their names and those that represent standard deviation values have 'std()' appended to their names

meanAndStd_data <- complete_data[, grep("std()|mean()|activity_id|subject_id", names(complete_data))]
dim(meanAndStd_data)

# 3. Use descriptive activity names to name the activities in the data set.

## simply merge the two dataframes. Checking the dimensions, we can see that no extra rows have been inserted.
meanAndStd_data <- merge(meanAndStd_data, activity_labels, by.x="activity_id", by.y="activity_id")
dim(meanAndStd_data)


# 4. Appropriately label the data set with descriptive variable names. 
### this has been done during the data loading


# 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

library(reshape2)
activityMelt <- melt(meanAndStd_data, id=c("subject_id", "activity_id", "activity_label"))
tidyData <- dcast(activityMelt, subject_id + activity_label ~ variable, mean)
dim(tidyData)
## The check with dim() reveals that the resulting data.frame has 180 rows by 81 columns. This 
## matches with the initial input of 30 subjects and 6 different activities (30x60=180).

## before we save, make the names of the mean value-columns a bit nicer:
tempColNames <- names(tidyData)[c(-1,-2)]
### replace first dot with an underscore
tempColNames <- sub("\\.", "_", tempColNames)
### remove trailing dots
tempColNames <- gsub("\\.", "", tempColNames)
### append a "_mean" to each column name
tempColNames <- paste(tempColNames, "_mean", sep="")
### replace the column names of the data.frame
names(tidyData)[c(-1,-2)] <- tempColNames

## write the data tidy set to the file system
write.table(tidyData, "./data/tidyDataSet.txt", row.names=FALSE)
