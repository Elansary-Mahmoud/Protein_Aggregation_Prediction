 #!/bin/bash         
clear 
count=`cat tools/tangowindow.out | wc -l` 
cut -f2 tools/tangowindow.out > f2.txt
while read start  
do      
	start=$(($start+1))
	echo $start >> tools/start.out
done < f2.txt

cut -f7 tools/tangowindow.out > f7.txt

while read end  
do      
	end=$(($end+$start-1))
	echo $end >> tools/end.out
done < f7.txt

start=`head -1 tools/tangowindow.out | cut -f2` 
start=$(($start+1))
echo "The start is $start"

end=`head -1 tools/tangowindow.out | cut -f7` 
end=$(($end+$start-1))
echo "The end is $end"
