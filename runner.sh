#!/bin/bash


for s in 1s 2s 2p 3s 3p 3d 4s 4p 4d 4f; do
	for Rc in 0.1 0.5 1 5 10; do
		bash boltzmann.sh $s $Rc 300
	done
gnuplot<<!
set ter png
set out 'PvT_${s}.png'
set lgscale y
set xlabel 'Temperature (K)'
set ylabel 'log Population'
filelist=system("ls population-*${s}*")
plot for [file in filelist] file u 1:2 w l lw 2 t file
!
done