#!/bin/bash

#this lieelt guy runs like this:
#GEMMoviemakerScript.sh $nameofmovie $numberofframes

mkdir moviestills
cd moviestills
for i in $(seq 0 $2)
do
		if [ $i -lt 10 ]
			then import -window GEM $1,still0000$i.jpg
		elif [ $i -lt 100 ]
			then import -window GEM $1,still000$i.jpg
		elif [ $i -lt 1000 ]
			then import -window GEM $1,still00$i.jpg
		elif [ $i -lt 10000 ]
			then import -window GEM $1,still0$i.jpg
		else 
			import -window GEM $1,still$i,$1.jpg
		fi
	#echo "bang;" | nc -q 0 localhost 9458 
	echo $i
done
cd ..
jpeg2yuv -f 25 -I p -j moviestills/$1,still%05d.jpg > $1.temp.mpg
avconv -i $1.temp.mpg -r 24 $1.mpg
rm -rf moviestills
rm $1.temp.mpg


