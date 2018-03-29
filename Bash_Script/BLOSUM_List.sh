function BLOSUMfn(){
if [[ "$mutant" == A ]]

  then
    column=2
fi

if [[ "$mutant" == R ]]

  then
    column=3
fi

if [[ "$mutant" == N ]]

  then
    column=4
fi

if [[ "$mutant" == D ]]

  then
    column=5
fi

if [[ "$mutant" == C ]]

  then
    column=6
fi

if [[ "$mutant" == Q ]]

  then
    column=7
fi


if [[ "$mutant" == E ]]

  then
    column=8
fi

if [[ "$mutant" == G ]]

  then
    column=9
fi

if [[ "$mutant" == H ]]

  then
    column=10
fi

if [[ "$mutant" == I ]]

  then
    column=11
fi

if [[ "$mutant" == L ]]

  then
    column=12
fi

if [[ "$mutant" == K ]]

  then
    column=13
fi


if [[ "$mutant" == M ]]

  then
    column=14
fi

if [[ "$mutant" == F ]]

  then
    column=15
fi

if [[ "$mutant" == P ]]

  then
    column=16
fi

if [[ "$mutant" == S ]]

  then
    column=17
fi

if [[ "$mutant" == T ]]

  then
    column=18
fi

if [[ "$mutant" == W ]]

  then
    column=19
fi


if [[ "$mutant" == Y ]]

  then
    column=20
fi

if [[ "$mutant" == V ]]

  then
    column=21
fi

if [[ "$mutant" == B ]]

  then
    column=22
fi

if [[ "$mutant" == J ]]

  then
    column=23
fi

if [[ "$mutant" == Z ]]

  then
    column=24
fi

if [[ "$mutant" == X ]]

  then
    column=25
fi

for i in 0 1 2 
do
   file_Name="tools/BLOSUM${Array[$i]}.txt"
output=`grep "^$original" $file_Name | cut -f$column`
echo "The BLOSUM${Array[$i]} $original$Position$mutant is $output"
echo $output >> $File_dir/List_BLOSUM${Array[$i]}.txt
done
echo -e "\n"

}

clear
Array=(62 45 80)
read -p "Please enter file directory  : " File_dir
#read -p "Please enter the BLOSUM Matrix Number : " BLOSUM
while read line_mutant_list  
	do      
	length=${#line_mutant_list}
	Position=${line_mutant_list:1:$((length-2))}
	original=${line_mutant_list:0:1}
	mutant=${line_mutant_list:$((length-1)):1}
	BLOSUMfn

done < $File_dir/Mutants_List.txt





