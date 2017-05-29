# Getting and Cleaning Data - Final Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset if it does not already exist in the working directory and unzip it
2. Reads the activity, subject and feature data
3. Loads and merges both the training and test datasets, keeping only those columns which
   reflect a mean or standard deviation
4. Reads the activity labels, gives and understable name and merges it with the clean data
5. Creates a tidy dataset with the mean value of each variable for each subject and activity pair.
6. Output the result in the file `tidy.txt`.

IMPORTANT NOTE: set your working directory in the 3th line.