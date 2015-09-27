
setwd("/Users/ahmedkammorah/Desktop/Self_study_Pro/Getting\ and\ Cleaning\ Data/Project/")


fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile="./UCI_HAR_Dataset.zip"
if(!file.exists(destFile)){
# Download data files 
# unzip data files 
    download.file(fileURL, destfile=destFile, method = "curl")  
    dateDownloaded <- date()
    dateDownloaded
    unzip(destFile)
}


setwd("./UCI\ HAR\ Dataset/")

# read feature file 
features = read.table("./features.txt")

# read x measurement train and test Files  
# trainX 
# testX
xTrainFile = "./train/X_train.txt"
xTestFile  = "./test/X_test.txt"

xTrain  = read.table( xTrainFile, col.names = features[,2])
xTest = read.table( xTestFile, col.names = features[,2])
# merge two measurement data xTrain and xTest 
xFull = rbind(xTrain, xTest) 


# extract mean/std measurement 
indexOfMeanSTD = features[grep("std|mean\\(",features[,2]),]
xMean_Std = xFull[,indexOfMeanSTD[,1]]

# Read y activity vaules and make col name activity 
yTrainFile = "./train/y_train.txt"
yTestFile = "./test/y_test.txt"

yTrain = read.table( yTrainFile, col.name = c("activity") )
yTest = read.table(yTestFile ,col.name = c("activity") )
# merge two activity data yTrain and yTest 
yFull = rbind(yTrain, yTest)

# compine y code with its activity label 
activityLabels = read.table("./activity_labels.txt")
fName <- function (y){activityLabels[y,2]}
yFull$name <- sapply(yFull,fName)

# compaine all data together X data and y with activety labels 
XWithY = cbind(yFull , xFull)

xMean_StdWithY = cbind(yFull , xMean_Std)



subjectTrainFile = "./train/subject_train.txt"
subjectTestFile = "./test/subject_test.txt"
subjectTrain = read.table(subjectTrainFile ,col.names = c('subject') )
subjectTest = read.table(subjectTestFile , col.names = c('subject'))

subjFull = rbind(subjectTrain, subjectTest)

XWithY_andSubject <- cbind(subjFull, XWithY)
XMean_StdWithY_andSubject <- cbind(subjFull, xMean_StdWithY)

# avg <- aggregate(XMean_StdWithY_andSubject, list(activity=yFull[,1], subject = subjFull[,1]), mean)

avg <- aggregate(xFull, list(activity=yFull[,1], subject = subjFull[,1]), mean)

write.csv(avg, file='./result.txt')

