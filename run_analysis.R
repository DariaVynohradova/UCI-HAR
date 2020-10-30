##### Use packages
library(dplyr)
library(stringr)
library(tidyverse)

##### 1. Merge training and test data
train <- read.table("C:/rlabwd/UCI HAR Dataset/train/X_train.txt")
test <- read.table("C:/rlabwd/UCI HAR Dataset/test/X_test.txt")
total <- rbind.data.frame(train, test)

##### 2. Extract mean and standard deviation for each measurement
features <- read.table("C:/rlabwd/UCI HAR Dataset/features.txt")
##### Store variable numbers with mean() and std() in the vecror
mean_std <- features[str_detect(features$V2, "mean") | str_detect(features$V2, "std"), 1]
mean_sdt_df<-total[, mean_std]

##### 3. Use activity names to format activity numbers in the data set
train_label <- read.table("C:/rlabwd/UCI HAR Dataset/train/y_train.txt")
test_label <- read.table("C:/rlabwd/UCI HAR Dataset/test/y_test.txt")

##### Convert numeric levels of activities to character ones
train_label$V1 <- as.factor(train_label$V1)
levels(train_label$V1) <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 
                            'SITTING', 'STANDING', 'LAYING')

test_label$V1 <- as.factor(test_label$V1)
levels(test_label$V1) <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 
                            'SITTING', 'STANDING', 'LAYING')

total_label <- rbind.data.frame(train_label, test_label)

##### 4. Apply names for each variable in the mean_std_df
mean_std_name <- as.character(features[str_detect(features$V2, "mean") | str_detect(features$V2, "std"), 2])
names(mean_sdt_df) <- mean_std_name

##### 5. Create tidy data set with the calculated average for each activity and subject
train_subject <- read.table("C:/rlabwd/UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("C:/rlabwd/UCI HAR Dataset/test/subject_test.txt")
total_subject <- rbind.data.frame(train_subject, test_subject)

total_df <- cbind.data.frame("Subject"=total_subject$V1, "Activity"=total_label$V1, mean_sdt_df)

##### Group data set by subject and activity and apply mean function for all the variables
final <- total_df %>% group_by(Subject, Activity) %>% summarise_all(mean) %>% view



