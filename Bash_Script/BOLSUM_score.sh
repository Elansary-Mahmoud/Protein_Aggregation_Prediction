 #!/bin/bash         
echo "Hello, World"
clear
read -p "Please enter BOLSUM matrix number  : " BLOSUM
read -p "Please enter Original Amino acid  : " row_A
read -p "Please enter Mutant Amino acid  : " column_A


if [[ "$column_A" == A ]]

  then
    column=2
fi

if [[ "$column_A" == R ]]

  then
    column=3
fi

if [[ "$column_A" == N ]]

  then
    column=4
fi

if [[ "$column_A" == D ]]

  then
    column=5
fi

if [[ "$column_A" == C ]]

  then
    column=6
fi

if [[ "$column_A" == Q ]]

  then
    column=7
fi


if [[ "$column_A" == E ]]

  then
    column=8
fi

if [[ "$column_A" == G ]]

  then
    column=9
fi

if [[ "$column_A" == H ]]

  then
    column=10
fi

if [[ "$column_A" == I ]]

  then
    column=11
fi

if [[ "$column_A" == L ]]

  then
    column=12
fi

if [[ "$column_A" == K ]]

  then
    column=13
fi


if [[ "$column_A" == M ]]

  then
    column=14
fi

if [[ "$column_A" == F ]]

  then
    column=15
fi

if [[ "$column_A" == P ]]

  then
    column=16
fi

if [[ "$column_A" == S ]]

  then
    column=17
fi

if [[ "$column_A" == T ]]

  then
    column=18
fi

if [[ "$column_A" == W ]]

  then
    column=19
fi


if [[ "$column_A" == Y ]]

  then
    column=20
fi

if [[ "$column_A" == V ]]

  then
    column=21
fi

if [[ "$column_A" == B ]]

  then
    column=22
fi

if [[ "$column_A" == J ]]

  then
    column=23
fi

if [[ "$column_A" == Z ]]

  then
    column=24
fi

if [[ "$column_A" == X ]]

  then
    column=25
fi

file_Name="tools/BLOSUM$BLOSUM.txt"
echo $file_Name
 grep "^$row_A" $file_Name | cut -f$column 


#awk -v row="$row" -v column="$column" 'NR==row {print $column}' tools/BLOSUM62.txt



