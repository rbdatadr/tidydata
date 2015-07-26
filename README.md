This repository contains the R code for cleaning the data set available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

1. First step is to read the data:

```
test <- read.csv("UCI HAR Dataset/test/X_test.txt", header=F, sep="")
train <- read.csv("UCI HAR Dataset/train/X_train.txt", header=F, sep="")
```
2. Each data frame contains 561 features. From these we need only 66 features. 

```
    sel <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 
             227, 228, 240, 241, 253, 254, 266:271, 345:350, 424:429, 
             503, 504, 516, 517, 529, 530, 542, 543)
    
    train.sel <- train[, sel]
    test.sel <- test[, sel]
```

3. Leading the activity labels:

```
    acts <- read.csv("UCI HAR Dataset/activity_labels.txt", header=F, sep="")
```

4. Leading activity information, for both test and train sets. The last line in each code group below, adds the activity information as an additional features. So, our data frames will have 67 features.

```
    test.act <- read.csv("UCI HAR Dataset/test/y_test.txt", header=F, sep="")
    test.act$V2 <- sapply(test.act$V1, function(i) acts$V2[i])
    test.sel$V562 <- test.act$V2

    train.act <- read.csv("UCI HAR Dataset/train/y_train.txt", header=F, sep="")
    train.act$V2 <- sapply(train.act$V1, function(i) acts$V2[i])
    train.sel$V562 <- train.act$V2
```

5. Merging test and train datasets

```
    data <- rbind(test.sel, train.sel)
```

6. Labeling the features of the data set with appropriate descriptive variable names. These names are extracted from the features.txt file provided in the original dataset. In the second line below, I remove the parenthesis, and replace “-“s with “_”s.

```
    names <- read.csv("UCI HAR Dataset/features.txt", header=F, sep="", as.is = T)
    names.sel <- c(gsub("\\(\\)", "", gsub("-", "_", names$V2[sel])), "activity")
    names(data) <- names.sel
```

7. The following lines, load and add subject information to the data frame as a new feature named “subject”.

```
    test.sub <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
    train.sub <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F, sep="")
    data$subject <- c(test.sub$V1, train.sub$V1)
```

8.  Computing the average of each feature for each activity and each subject. This is done using melt and dcast to group values of each variable by subject and activity, and then compute the average. 

```
    library(reshape2)
    mdata <- melt(data, id=c("subject", "activity"))
    cdata <- dcast(mdata, subject + activity ~ variable, mean)
```

9. Writing the result into a text file

```
    write.csv(cdata, "dataset.txt", row.names = FALSE)
```








