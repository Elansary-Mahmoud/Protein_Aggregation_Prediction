 #!/bin/bash         
clear
read -p "Please enter Mutation position  : " mut_pos
read -p "Please enter Start of Tango zone  : " start
read -p "Please enter end of Tango zone  : " end

if [ "$mut_pos" -le "$start" ]

  then
    	distance=$(($start-$mut_pos))
elif [ "$mut_pos" -ge "$end" ]
  then
	distance=$(($mut_pos-$end))
else 
	distance="Inside the tango zone"
fi

echo $distance
