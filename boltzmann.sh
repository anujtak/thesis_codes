#!/bin/bash

cat<<!
Usage: ./boltzmann.sh <State eg: 1s> <Temp eg: 300>
!

mkdir -p output
rm -rf temp 

#################################  Probability vs T ################################################

s=$1
file=`ls data | grep $s`
Rc=$2
line=`echo $Rc | awk '{print $1*10}'`

for i in $(seq 1 300);do
	rm -rf temp
	T=`echo $i | awk '{print $1*3.16683}'`
	for j in data/*; do
		En=`sed "${line}q;d" $j | awk '{print $3}'`
		term=`echo $En $T | awk '{print exp(-1*$1/$2)}'`
		echo $term >> temp
	done
	denom=`awk '{sum+=$1} END {print sum}' temp`
	Ei=`sed "${line}q;d" data/$file | awk '{print $3}'`
	numer=`echo $Ei $T | awk '{print exp(-1*$1/$2)}'`
	population=`echo $numer $denom | awk '{print $1/$2}'`
	echo $i $population >> population-${s}-${Rc}
done

fn=population-${s}-${Rc}

gnuplot<<!
set ter png
se ou 'PvsT_${s}_${Rc}.png'
plot '$fn' u 1:2 w l t 'Probability vs Temperature' lw 2
!

mv PvsT_${s}_${Rc}.png output/
#mv $fn output/


#################################  Probability vs Rc ################################################
<<c
n=`cat data/eng_1s.dat | wc -l`
t=$2

T=`echo $t | awk '{print $1*3.16683}'`


for i in $(seq 1 $n); do
	rm -rf temp
	for j in data/*; do
		En=`sed "${i}q;d" $j | awk '{print $3}'`
		term=`echo $En $T | awk '{print exp(-1*$1/$2)}'`
		echo $term >> temp
	done
	denom=`awk '{sum+=$1} END {print sum}' temp`
	Ei=`sed "${i}q;d" data/$file | awk '{print $3}'`
	numer=`echo $Ei $T | awk '{print exp(-1*$1/$2)}'`
	population=`echo $numer $denom | awk '{print $1/$2}'`
	rc=`echo $i | awk '{print $1/10}'`
	echo $rc $population >> population_${s}_${t}K.dat
done

fn=population_${s}_${t}K.dat

gnuplot<<!
set ter png
se ou 'PvsT_${s}_${t}K.png'
plot '$fn' u 1:2 w l t 'Probability vs Rc' lw 2
!

mv PvsT_${s}_${t}K.png output/
c
