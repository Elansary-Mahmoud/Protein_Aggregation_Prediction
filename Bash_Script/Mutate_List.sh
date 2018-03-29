 #!/bin/bash  
clear
read -p "Please enter the file directory : "  File_dir
read -p "Please enter the file Name : "  File_Name
read -p "Correction parameter " correction
while read line_mutant_list 
do 
length=${#line_mutant_list}
Position=${line_mutant_list:1:$((length-2))}
Position=$((Position + correction))
original=${line_mutant_list:0:1}
mutant=${line_mutant_list:$((length-1)):1}
counter=1
count=$(($Position/60))
move=$(($Position - $count*60 ))
	if [ "$count" -eq 0 ]
	then
		count=2	
	else
	count=$((count+2)) 
	fi
rm $File_dir/$original$((Position-correction))$mutant/$original$Position$mutant.fasta
	while read line  
	do      
		if [ "$counter" -eq  "$count" ]

	  	then
			test=${line:$((move-1)):1}
			if [ "$original" == "$test" ]
			then
	    		line=${line:0:$((move-1))}$mutant${line:$((move)):60}
			else 
			echo " point mutation position is wrong "
			fi
		fi

		 counter=$(($counter + 1))
		 echo $line >> $File_dir/$original$((Position-correction))$mutant/$original$Position$mutant.fasta

	done < $File_dir/$File_Name

echo "MUTANT '$original$Position$mutant' is succesufly mutated and saved "
done < $File_dir/Mutants_List.txt
