Getting and Cleaning Data Course Project
=========================

This document describes the result of the 'Getting and Cleaning Data Course Project'. 
Data from the [**Human Activity Recognition Using Smartphones Data Set**](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) is being loaded, merged, tidied up and a data set describing the mean measurement values for each subject (n=30) and activity (n=6) is written to the file named 'tidyDataSet.txt'.
Details on how the data have been treated can be found in the section below. A description of the resulting data set and it's variables can be found in the file 'CodeBook.txt'.

The file 'run_analysis.R' 
-------------------------

The R script assumes that the [**UCI Dataset**](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip) has been unzipped in a subdirectory named 'data' relative to the script. I.e. the directory structure should be layed out as follows:

```
run_analysis.R
data/UCI HAR Dataset.zip
data/UCI HAR Dataset/activity_labels.txt
data/UCI HAR Dataset/features.txt
data/UCI HAR Dataset/test/subject_test.txt
data/UCI HAR Dataset/test/X_test.txt
data/UCI HAR Dataset/test/y_test.txt
data/UCI HAR Dataset/train/subject_train.txt
data/UCI HAR Dataset/train/X_train.txt
data/UCI HAR Dataset/train/y_train.txt
```

### Step1

In the first step, the script loads the textfiles mentioned above into internal dataframes. After loading the basic files and investigating with dim(), we have the following data available:
```
- activity_labels:    6x2         (activity_id, activity_name)
- features:           561x2       (feature_id, feature_name)
- subject_train:      7352x1      (subject_id)
- X_train:            7352x561    ("features")
- y_train:            7352x1      (activity_id)
- subject_test:       2947x1      (subject_id)
- X_test:             2947x561    ("features")
- y_test:             2947x1      (activity_id)
```

The sizes of the training and test data sets correspond to the description of the original data set information: * 70% training data and 30% test data
* 30 subjects
* 6 different activities

### Step 2

In the second step of the script, the independent dataframes are merged horizontally and vertically as follows:

```
X_train|y_train|subject_train
X_test |y_test |subject_test
```

### Step 3

In the third step, a subset of the original data set is built by selecting only the mean value and standard deviation features (also, the subject and activity ids are retained.)

### Step 4

Using the library `reshape2`, the data is reshaped using the melt() and dcast() functions. Through this, the data frame represents the mean values of each standard deviation and mean of each feature per subject and activity.  Checking the dimensions reveals that the resulting data.frame has 180 rows by 81 columns. This 
matches with the initial input of 30 subjects and 6 different activities (30x60=180).

After making the variable names more descriptive, the dataframe is written out to the file 'data/tidyDataSet.txt'. 

```
> head(tidyData)[,1:6]
  subject_id     activity_label tBodyAcc_meanX_mean tBodyAcc_meanY_mean tBodyAcc_meanZ_mean tBodyAcc_stdX_mean
1          1             LAYING           0.2215982        -0.040513953          -0.1132036        -0.92805647
2          1            SITTING           0.2612376        -0.001308288          -0.1045442        -0.97722901
3          1           STANDING           0.2789176        -0.016137590          -0.1106018        -0.99575990
4          1            WALKING           0.2773308        -0.017383819          -0.1111481        -0.28374026
5          1 WALKING_DOWNSTAIRS           0.2891883        -0.009918505          -0.1075662         0.03003534
6          1   WALKING_UPSTAIRS           0.2554617        -0.023953149          -0.0973020        -0.35470803
```
