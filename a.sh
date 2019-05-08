#!/bin/bash
cat<<!
USAGE: ./a.sh <Rc>
!

rm -rf temp* *.out *.png

read -p "Press CTRL+C to quit or ENTER to continue"
Rc=$(echo $1 | awk '{print $1*10}')
for t in $(seq 1 300); do # Loop over temperatures
	beta=$(echo $t | awk '{print (1/($1*3.16683))}')
	rm -rf temp*

	for i in *.dat; do
		sed "${Rc}q;d" $i | awk -vb=$beta '{print exp(-1*$3*b)}' >> temp1
		sed "${Rc}q;d" $i | awk -vb=$beta '{print -1*$3*exp(-1*$3*b)}' >> temp2
		sed "${Rc}q;d" $i | awk -vb=$beta '{print $3*$3*exp(-1*$3*b)}' >> temp3
	done
	q0=`awk '{sum+=$1} END {print sum}' temp1`
	q1=`awk '{sum+=$1} END {print sum}' temp2`
	q2=`awk '{sum+=$1} END {print sum}' temp3`
	echo $t $q0 >> q0.out
	echo $t $q1 >> q1.out
	echo $t $q2 >> q2.out
done

seq 1 300 > temperature
cat q0.out | awk -vb=$beta '{print -1*(1/b)*log($2)}' > temp
paste temperature temp > F.out
paste q0.out q1.out | awk '{print -1*$2/$4}' > temp
paste temperature temp > U.out
paste q0.out q1.out q2.out | awk -vbeta=$beta '{print beta^2*($6/$2)-($4/$2)^2}' > temp
paste temperature temp > C.out
paste q0.out q1.out | awk -vbeta=$beta '{print log($2)+beta*($4/$2)}' > temp
paste temperature temp > S.out

gnuplot<<!
set ter png
se ou 'FvsT.png'
pl 'F.out' u 1:2 w l t 'F vs T' lw 2
se ou 'UvsT.png'
pl 'U.out' u 1:2 w l t 'U vs T' lw 2
se ou 'CvsT.png'
pl 'C.out' u 1:2 w l t 'C vs T' lw 2
se ou 'SvsT.png'
pl 'S.out' u 1:2 w l t 'S vs T' lw 2
!


mkdir -p $Rc

mv *.out $Rc
mv *.png $Rc