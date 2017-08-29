#!/bin/bash
## This script strips uneeded information from NFDUMP output and combines it with geolocation information for world heatmap purposes.
## This script requires that geoiplookup be installed. This is available from most repo's and can be install with yum or apt.


#set -x for debug. Add # in front of line if you don't want to see the detail output.
set -x

#clean temp files from previous runs
truncate -s 0 websites.txt
truncate -s 0 usites.txt
truncate -s 0 geo-ip.txt

#Set Path to your folder with nfdump files infront of the # in the line below 
VarPath=  #<-----this is where you put your folder that needs to be analysed.

#1. Recursive nfdump analysis for time ended, source address, destination address, destination port, protocol, packet and byte counts.
#2. It is then filtered for port 80 and port 443 traffic and pumped out to websites.txt
#3. Changing the output fields are simple, please visit http://manpages.ubuntu.com/manpages/zesty/man1/nfdump.1.html for full details.
#4. The file is then read -4 end lines (summary from nfdump), filtered to output column 4 (destination IP in this case), piped to sort the
#IP's in ascending order, duplicates trimmed (note you have to sort before uniq otherwise you will have duplicates), then any lines with
#"Src" is removed and the output piped to usites.txt
#5. Loop to read through the output file, perform Geo lookup and keeping only the relevant fields for my task. Please review options
#for your own needs.
# 6. The variable produced by action 5 is then combined with the IP and piped to file geo-ip.txt
#This file can be easily used in excel & calc (depending on lines) and visualisation tools for graphing and heatmapping.


nfdump -R $VarPath -o "fmt:%te %sa %da %dp %pr %pkt %byt" 'dst port 443 or dst port 80' > websites.txt
head -n -4 websites.txt|awk '{print $4}'|sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4|uniq |grep -v Src > usites.txt
while read VarA; do
        VarB=$(geoiplookup $VarA |grep -i city|cut -d"," -f 2,4,5|cut -d":" -f2)
        echo $VarA,$VarB >> geo-ip.txt
done < usites.txt
