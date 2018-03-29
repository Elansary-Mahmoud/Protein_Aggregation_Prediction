 #!/bin/bash  
clear
read -p "Please enter the file directory : "  File_dir
read -p "Please enter the file Name : "  File_Name
read -p "Please enter Mutation postion  : " Position
read -p "Please enter Original residue   : " original
read -p "Please enter Mutated residue  : " mutant

counter=1
count=$(($Position/60))
move=$(($Position - $count*60 ))
echo "count $count and move $move"
	if [ "$count" -eq 0 ]
	then
		echo "count is zero"
		count=2	
	else
	count=$((count+2)) 
	fi

while read line  
do      
       echo $counter
	if [ "$counter" -eq  "$count" ]

  	then
		test=${line:$((move-1)):1}
		echo "the test is $test"
		if [ "$original" == "$test" ]
		then
		echo " Point mutation position is correct "
    		line=${line:0:$((move-1))}$mutant${line:$((move)):60}
		else 
		echo " point mutation position is wrong "
		fi
	fi

	 counter=$(($counter + 1))
	 echo $line >> $File_dir/$original$Position$mutant.fasta

done < $File_dir/$File_Name
