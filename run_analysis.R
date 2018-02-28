## load the necessary packages
library(readr)
library(dplyr)

#loading of features, activity labels and subjects.
features <- read.table('features.txt')
desired_features <- grepl("mean[^Freq]()|std()",features[,2])
activity_lbls <- read.table('activity_labels.txt')

subject_train <- read.table('train/subject_train.txt')
subject_train <- rename(subject_train,subject=V1)

subject_test <- read.table('test/subject_test.txt')
subject_test <- rename(subject_test,subject=V1)

## loading of the test set  and selection of wanted variables
test <- read.table('./test/X_test.txt')
names(test) <- features$V2
test <- test[,desired_features]
test_labels <- read.table('test/y_test.txt')
test_labels$V2 <- factor(test_labels$V1,labels = activity_lbls$V2)
test_labels <- rename(test_labels,activity_id=V1,activity_name=V2)
test_all <- cbind(subject_test,test_labels,test)

## loading of the train set  and selection of wanted variables

train <- read.table('train/X_train.txt')
names(train) <- features$V2
train <- train[,desired_features]
train_labels <- read.table('train/y_train.txt')
train_labels$V2 <- factor(train_labels$V1,labels = activity_lbls$V2)
train_labels <- rename(train_labels,activity_id=V1,activity_name=V2)
train_all <- cbind(subject_train,train_labels,train)

## merging of the two data sets along with subject and activity name
data_all <- rbind(train_all,test_all)
## elimination of activity id, which is not necessary, because activity name is sufficient
data_all<-data_all[,-2]
## creation of the tidy data set
tidy_data <- data_all %>% 
                group_by(subject,activity_name) %>%
                summarise_all(mean) %>%
                print()
##creation of the tidy data set file
write.table(tidy_data,file = "./tidy_data.txt", row.name=FALSE)
