README
========================================================
Submission: df_Final.txt
--------------------------------------------------------

**Submitted Tidy Data Description**
The final transformed data or submitted tidy data set can be read into R via the following command:
```{r}
theURL <- "https://s3.amazonaws.com/coursera-uploads/user-e05c1cc6754a16e0bee7ccd1/972136/asst-3/ee663650e1d011e3b9d5c185ab390dc2.txt"
download.file(file=theURL, destfile="location.txt")
read.table(file="location.txt", sep=",")

```
It has 88 variables: the first variable or column name is "Subjects" and contains the subject participants respresented nominally from 1 to 30. The second variable called "Activites" contains the six different activities each subject was engaged in while the 
rest of the 86 variables are the corresponding averages of the mean and standard deviation calculations of the sensor measurements during activities. And there are 180 rows corresponding to 30 subjects each engaged in 6 activities and each cell is an average.