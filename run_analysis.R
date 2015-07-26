test <- read.csv("UCI HAR Dataset/test/X_test.txt", header=F, sep="")
train <- read.csv("UCI HAR Dataset/train/X_train.txt", header=F, sep="")
sel <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201, 202, 214, 215, 227, 228, 240, 241, 253, 254, 266:271, 345:350, 424:429, 503, 504, 516, 517, 529, 530, 542, 543)

train.sel <- train[, sel]
test.sel <- test[, sel]

acts <- read.csv("UCI HAR Dataset/activity_labels.txt", header=F, sep="")
test.act <- read.csv("UCI HAR Dataset/test/y_test.txt", header=F, sep="")
test.act$V2 <- sapply(test.act$V1, function(i) acts$V2[i])
test.sel$V562 <- test.act$V2

train.act <- read.csv("UCI HAR Dataset/train/y_train.txt", header=F, sep="")
train.act$V2 <- sapply(train.act$V1, function(i) acts$V2[i])
train.sel$V562 <- train.act$V2

data <- rbind(test.sel, train.sel)

names <- read.csv("UCI HAR Dataset/features.txt", header=F, sep="", as.is = T)
names.sel <- c(gsub("\\(\\)", "", gsub("-", "_", names$V2[sel])), "activity")
names(data) <- names.sel


test.sub <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
train.sub <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F, sep="")
data$subject <- c(test.sub$V1, train.sub$V1)

library(reshape2)
mdata <- melt(data, id=c("subject", "activity"))
cdata <- dcast(mdata, subject + activity ~ variable, mean)

write.csv(cdata, "dataset.txt", row.names = FALSE)