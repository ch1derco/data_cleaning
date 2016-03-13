## Assignment: Getting and Cleaning Data Course Project
#
#  create one R script called run_analysis.R that does the following.
#  A) Merges the training and the test sets to create one data set.
#  B) Extracts only the measurements on the mean and standard deviation for each measurement.
#  C) Uses descriptive activity names to name the activities in the data set
#  D) Appropriately labels the data set with descriptive variable names.
#  E) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
setwd("./Coursera/DataClean")
#  A) Merges the training and the test sets to create one data set.

# read all relevant tables
#
# load label and column names data
#
	featurenames 	<- read.table("features.txt")
	
# load train Data
#
	train_subject 	<- read.table("subject_train.txt")
	train_x		<- read.table("X_train.txt")
	train_y		<- read.table("y_train.txt")
#
	names(train_subject)	<- "subjectID"		#column name for subject files
	names(train_x)		<- featurenames$V2	#column name for measurement files
	names(train_y)		<- "activity"		#column name for label files		

# load Test Data
	test_subject 	<- read.table("subject_test.txt")
	test_x		<- read.table("x_test.txt")
	test_y		<- read.table("y_test.txt")
#
	names(test_subject)	<- "subjectID"		#column name for subject files
	names(test_x)		<- featurenames$V2	#column name for measurement files
	names(test_y)		<- "activity"		#column name for label files		

# Bind files into 1 dataset
	traindata 	<- cbind(train_subject, train_y, train_x)
	testdata  	<- cbind(test_subject, test_y, test_x)

#  B) Extracts only the measurements on the mean and standard deviation for each measurement.
	columnsneed	<- grepl("mean|std", featurenames$V2)
	datastdmn 	<- rbind(traindata, testdata)[,c(TRUE, TRUE, columnsneed)]


#  C) Uses descriptive activity names to name the activities in the data set

	datastdmn$activity <- factor(datastdmn$activity, labels=c("walking", "walking upstairs", "walking downstairs", "sitting", "standing", "laying"))

#  D) Appropriately labels the data set with descriptive variable names.
#
	names(datastdmn) <- gsub("tBody", 	"body_time", names(datastdmn))
	names(datastdmn) <- gsub("tGravity", 	"gravity_time", names(datastdmn))
	names(datastdmn) <- gsub("fBody", 	"body_fft", names(datastdmn))
	names(datastdmn) <- gsub("fGravity", 	"gravity_fft", names(datastdmn))


#  E) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
	datastdmn2	<- melt(datastdmn, id=c("subjectID", "activity"))
	datastdmn3	<- dcast(datastdmn2, subjectID+activity ~ variable, mean)

	write.table(datastdmn3, file = "./step5_data.txt")	
#  
