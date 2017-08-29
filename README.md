# Nfdump-Geo
Basic script to output NFDUMP data into delimited format with most pertinent fields to create a heatmap of destination IP's. The script can be easily modified by playing with the nfdump outputs and output formatting to produce various results. 

The steps performed in the script as per following numbered items. 

1. Recursive nfdump analysis for time ended, source address, destination address, destination port, protocol, packet and byte counts.
2. It is then filtered for port 80 and port 443 traffic and pumped out to websites.txt
3. Changing the output fields are simple, please visit http://manpages.ubuntu.com/manpages/zesty/man1/nfdump.1.html for full details.
4. The file is then read -4 end lines (summary from nfdump), filtered to output column 4 (destination IP in this case), piped to sort the
IP's in ascending order, duplicates trimmed (note you have to sort before uniq otherwise you will have duplicates), then any lines with
"Src" is removed and the output piped to usites.txt
5. Loop to read through the output file, perform Geo lookup and keeping only the relevant fields for my task. Please review options
for your own needs.
 6. The variable produced by action 5 is then combined with the IP and piped to file geo-ip.txt
This file can be easily used in excel & calc (depending on lines) and visualisation tools for graphing and heatmapping.

There is no license here. Just give props if you use it.
