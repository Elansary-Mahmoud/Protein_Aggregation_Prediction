clear
read -p "Please enter the file directory : "  File_dir

while read line_Proteins_Names 	
do      

	if [ -e $File_dir/$line_Proteins_Names/SIFT.txt ] 
	then



		#length=${#line_mutant_list}

		sed 's/^ *//' $File_dir/$line_Proteins_Names/SIFT.txt > $File_dir/$line_Proteins_Names/SIFT.txt.tmp
		mv $File_dir/$line_Proteins_Names/SIFT.txt.tmp $File_dir/$line_Proteins_Names/SIFT.txt
		
		counter=1
			while read line_SIFT
			do  


					if [ $counter -eq 1 ]
					then
						if [[ ! $line =~ [^[:space:]] ]] ; then
						output_length=${#line_SIFT}
						output=${line_SIFT:$((output_length-5)):4}
						Position=`echo $line_SIFT | awk '{print $4}'`
						original=`echo $line_SIFT | awk '{print $6}'`
						mutant=`echo $line_SIFT | awk '{print $8}'`
						counter=$((counter+1))	
						rm $File_dir/$line_Proteins_Names/SIFT_.txt
						rm $File_dir/$line_Proteins_Names/$original$Position$mutant/SIFT_$original$Position$mutant.txt
						echo  $output >> $File_dir/$line_Proteins_Names/$original$Position$mutant/Score_$original$Position$mutant.txt
						#echo $original$Position$mutant >> $File_dir/$line_Proteins_Names/Have_SIFT.txt
						echo "Score created for $original$Position$mutant  $line_Proteins_Names"
						fi

					elif [ $counter -eq 2 ]
					then 
						output_length=${#line_SIFT}
						output=${line_SIFT:$((output_length-4)):4} 
						counter=$((counter+1))	
						rm $File_dir/$line_Proteins_Names/$original$Position$mutant/AVG_$original$Position$mutant.txt
						echo  $output >> $File_dir/$line_Proteins_Names/$original$Position$mutant/AVG_$original$Position$mutant.txt 
						echo "AVG created for $original$Position$mutant  $line_Proteins_Names"

					elif [ $counter -eq 3 ]
					then

						counter=$((counter+1))
					else 

						counter=1
					fi

 		#paste $File_dir/$line_Proteins_Names/$line_mutant_list/Score_$line_mutant_list.txt.tmp $File_dir/$line_Proteins_Names/$line_mutant_list/AVG_$line_mutant_list.txt.tmp > $File_dir/$line_Proteins_Names/$line_mutant_list/SIFT_$line_mutant_list.txt

			done < 	$File_dir/$line_Proteins_Names/SIFT.txt	


	fi

done < $File_dir/Proteins_Names.txt


