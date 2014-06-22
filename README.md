## run_analysis.R

This is the course project for the _Getting and Cleaning Data_ Coursera course.

There were five tasks to complete to pass this project:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The script starts with _Task 0_ downloading the required file to the working
directory, then decompressing it into it's default directory 
(`./UCI HAR Dataset`).  In the script this is commented out so that
it doesn't get run over and over while testing the rest of the script.

Next, _Task 1_, _Task 2_, and _Task 4_ were all done together.  I started by
reading all eight required files from the decompressed archive.  The files were:

* Files that list the subject numbers:
  * `./UCI HAR Dataset/test/subject_test.txt`
  * `./UCI HAR Dataset/train/subject_train.txt`
* Files that list the activity (by number)
  * `./UCI HAR Dataset/test/Y_test.txt`
  * `./UCI HAR Dataset/test/train/Y_train.txt`
* A file that lists the activity names that correspond to the activity number:
  * `./UCI HAR Dataset/activity_lables.txt`
* Files that contain the measurement data.  Each file contains 561 measurements:
  * `./UCI HAR Dataset/test/X_test.txt`
  * `./UCI HAR Dataset/train/X_train.txt`
* A file that lists names of each measurement:
  * `./UCI HAR Dataset/features.txt`

The measurement data was subsetted by removing any column that did not contain
_mean_, _Mean_, _std_, or _Std_.  The three training files and the three testing
files were then contatentated using `cbind()`, and finally the training data and
testing data were contactenated using `rbind()`.  The resulting dataset is named
_allData_.

Next I tackled _Task 3_, by using cbind() followed by slicing to add a column of
activity names that correspond to the activity numbers.  I then removed a few
columns from the dataset that aren't needed.

Finally, in _Task 5_ I calculated the mean for each measurement variable
(_allData[,3:88]_) for every unique combination of _Subject_ and _ActivityName_.
I'm sure that there is an easier way to do this, but I ended up
using nested _for_ loops (three of them).  This is neither efficient nor
elegant, but it does work.  This yields a data set (_tidyData_) that is 180 (30 subjects by six activities) 
rows, with 86 measurement variables (total of 88 columns).  This is a wide data 
set per the discussions in the Coursera forums.  I added the names back into the 
data set, and write out the results.  Note that while I write out the results in
a .csv file, I also write them with the same arguments but give it a .txt
extension, because that's what Coursera's upload utility requires.

