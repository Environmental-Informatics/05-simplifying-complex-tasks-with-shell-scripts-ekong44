#!/bin/bash

# Author - Eric Kong
# Date - 2/19/20
# ABE 651 Lab 5 
# A script that processes the StationData subdirectory

# purge modules such as anaconda before loading gmt
module purge 
module load gmt

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
# StationData subdirectory - longitude and latitude

awk '/Longitude/ {print -1 * $NF}' StationData/*.txt > Long.list # negative longitude because west of Prime Meridian
awk '/Latitude/ {print $NF}' StationData/*.txt > Lat.list
paste Long.list Lat.list > AllStation.xy

# HigherElevation subdirectory - longitude and latitude

awk '/Longitude/ {print -1 * $NF}' HigherElevation/*.txt > HELong.list # negative longitude because west of Prime Meridian
awk '/Latitude/ {print $NF}' HigherElevation/*.txt > HELat.list
paste HELong.list HELat.list > HEStation.xy

# Using GMT to make a plot and view the figure
gmt pscoast -JU16/4i -R-93/-86/36/43 -A -B2f0.5 -Cblue -Dh -Ia/blue -Na/orange -P -K -V > SoilMoistureStations.ps # high res rivers, coastline, and political boundaries
gmt psxy AllStation.xy -J -R -Sc0.15 -Gblack -K -O -V >> SoilMoistureStations.ps # black circles for all stations
gmt psxy HEStation.xy -J -R -Sc0.05 -Gred -O -V >> SoilMoistureStations.ps # smaller red circles for high elevation stations
gv SoilMoistureStations.ps &

# Part 3: convert figure into other image formats
ps2epsi SoilMoistureStations.ps SoilMoistureStations.epsi
gv SoilMoistureStations.epsi &
convert -density 150x150 SoilMoistureStations.epsi SoilMoistureStations.tiff
