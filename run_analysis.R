
library(readr)
library(dplyr)

features <- read.table('features.txt')
desired_features <- grepl("mean|std",features[,2])
activity_lbls <- read.table('activity_labels.txt')

subject_train <- read.table('train/subject_train.txt')
subject_train <- rename(subject_train,subject=V1)

subject_test <- read.table('test/subject_test.txt')
subject_test <- rename(subject_test,subject=V1)

test <- read.table('./test/X_test.txt')
names(test) <- features$V2
test <- test[,desired_features]
test_labels <- read.table('test/y_test.txt')
test_labels$V2 <- factor(test_labels$V1,labels = activity_lbls$V2)
test_labels <- rename(test_labels,activity_id=V1,activity_name=V2)
test_all <- cbind(subject_test,test_labels,test)

train <- read.table('train/X_train.txt')
names(train) <- features$V2
train <- train[,desired_features]
train_labels <- read.table('train/y_train.txt')
train_labels$V2 <- factor(train_labels$V1,labels = activity_lbls$V2)
train_labels <- rename(train_labels,activity_id=V1,activity_name=V2)
train_all <- cbind(subject_train,train_labels,train)

data_all <- rbind(train_all,test_all)

tidy_data <- data_all %>% 
                group_by(subject,activity_id,activity_name) %>%
                summarise_all(mean) %>%
                print()
                
write.table(tidy_data,file = "./tidy_data.txt", row.name=FALSE)
