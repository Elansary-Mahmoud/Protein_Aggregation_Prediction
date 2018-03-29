 #!/bin/bash  
clear
read -p "Please enter folder name  : " FOlder_Name 
while read line  
do      
	echo tools/Data_Set/$FOlder_Name/$line
	mkdir -m 700 tools/Data_Set/$FOlder_Name/$line
done < tools/Data.txt
