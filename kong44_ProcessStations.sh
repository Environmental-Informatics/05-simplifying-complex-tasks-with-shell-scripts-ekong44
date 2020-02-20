#!/bin/bash


# Author - Eric Kong
# Date - 2/19/20
# ABE 651 Lab 5 
# A script that processes the StationData subdirectory


# Part 1: Identify and separate out high elevation 

# Checking to see if the directory already exists
# Directory has to be made before files can be copied to them
if [ -d "HigherElevation" ] # check to see if directory exists, from link in assignment
then 
	echo -e "\t'HigherElevation' directory already exists"
else
	mkdir HigherElevation
fi

# checking for stations with >200 elevation and copying them to a different directory
for data_set in StationData/* # from assignment text
do 
	in_the_clouds=`basename "$data_set"` # basename function to extract only the file name
	if
	ack -B 3 'Altitude: [>200]' $data_set # search file and display lines 
	then cp StationData/$in_the_clouds HigherElevation/$in_the_clouds
	fi
done

# Part 2: Plot locations of all stations and highlight higher elevation

