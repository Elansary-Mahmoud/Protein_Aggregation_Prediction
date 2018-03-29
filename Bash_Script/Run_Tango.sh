 #!/bin/bash         
#clear
function myproc(){
read -p "Please enter file directory  : " File_dir
#	while read line  
#	do      
#		cp $File_dir/Options_old.txt $File_dir/$line
		#echo "agadirwrapper $File_dir/$line $File_dir/$line/Options.txt"
	
		cd $File_dir
		pwd
echo "agadirwrapper $File_dir/M52I.fasta $File_dir/Options1.txt"
		tools/agadirwrapper/agadirwrapper M52I.fasta Options1.txt
#done < $File_dir/Mutants_List.txt 

}

myproc
