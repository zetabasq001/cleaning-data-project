CodeBook
========================================================

**Objective of CodeBook**
This is a Codebook describing the variables, data, and transformations that 
the author applied to complete the Course Project for *Getting
and Cleaning Data,* a MOOC presented by John Hopkins University via Coursera Platform.

**Description of Raw Data**
The data was collected via a wearable device with smartphones while 30 subjects
engaged in six physical activites. 561 measurements were collected
during these six activities.

Data Set Reference: *Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

**How Data was Manipulated and Transformed**

*Download and Unzip*
The data was originally downloaded and unziped.  A total of 8 files were scanned in corresponding to test/training subjects, test/training data sets, test/training activites, feature variables names, and word description of activities.

*Select and Replace*
The grep function was used to find vector positions of feature variable names with mean() and std() embedded in them for later selection reducing feature variables from 561 to 86 feature variables.
The gsub function was used to replace short feature variable names by longer word description e.g. from Acc to Accelerometer. Furthermore, nominal activites numbers were changed to word description of activities e.g. from 5 to STANDING by using their vector position.
The strsplit function was used to separate the numeral from the word descriptions of activites and feature variables and the numerals removed.

*Merge both Data Sets*
A matrix was created by row to accomodate the test/training data sets and the feature variable names were placed in as the names of columns, then the desired feature variables were selected from matrix that was then converted to a data frame. This data frame was then attached to the Subject and Activities columns for a total of 88 columns.

*Reshape, Melt, and Casting*
The reshape2 package was attached and the melt and dcast functions were used to reshape and find the averages of means and standard deviations corresponding to subject and activity. 

Using lapply function the 88 column data frame was broken into a list with 86 components corresponding to a melted data frame i.e. each melted data frame contained subjects, activities, and one feature variable. Then the dcast function was used on each component to find the average using the mean function for each subject and each activity using the formula parameter: Subjects~Activities. Then each component or data frame was melted and then reassembled: arriving at final data frame with 86 feature columns, 180 rows corresponding to 30 subjects and 6 physical activities, and the cells corrsponding to the averages that is an average of example given, "Subject 1, STANDING, feature variable".

The R script code contains comments with additional details.