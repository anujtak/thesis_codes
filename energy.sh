#!/bin/bash
rm temp* f.out q.out F.out u.out c.out s.out Q.out U.out C.out S.out *.png
t=$1
echo $t
b=`echo $t | awk '{print 1/(1*$1*3.16683e-6)}'`
echo $b
for i in $(seq 20 150); do
	sum=0
	for j in *.dat; do
		sed "${i}q;d" $j | awk -vt=$t '{print exp(-1*$3/(1*t*3.16683e-6))}' >> temp1
		sed "${i}q;d" $j | awk -vt=$t '{print $3*exp(-1*$3/(1*t*3.16683e-6))}' >> temp2
		sed "${i}q;d" $j | awk -vt=$t '{print ($3)^2*exp($3/(1*t*3.16683e-6))}' >> temp3
	done
	awk '{sum+=$1} END {print sum}' temp1 >> q.out
	awk '{sum+=$1} END {print sum}' temp2 >> q1.out
	awk '{sum+=$1} END {print sum}' temp3 >> q2.out
done
cat q.out | awk -vt=$t '{print -1*t*3.16683e-6*log($1)}' > f.out
cat temp | awk -vb=$b '{print -1*b*b*$1}' > c.out
paste q.out u.out | awk -vb=$b '{print 1*log($1)+1*b*$2}' > s.out
seq 2.0 0.1 15 > temp
paste temp q.out > Q.out
paste temp f.out > F.out
paste temp u.out > U.out
paste temp c.out > C.out
paste temp s.out > S.out
gnuplot<<!
se xl 'Rc'
se yl 'Q'
plot 'Q.out' u 1:2 w l t 'Q vs Rc'
se ter png
se out 'QvsRc.png'
rep
se term wxt
se xl 'Rc'
se yl 'F'
plot 'F.out' u 1:2 w l t 'F vs Rc'
se ter png
se out 'FvsRc.png'
rep
se term wxt
se xl 'Rc'
se yl 'U'
plot 'U.out' u 1:2 w l t 'U vs Rc'
se ter png
se out 'UvsRc.png'
rep
se term wxt
se xl 'Rc'
se yl 'C'
plot 'C.out' u 1:2 w l t 'C vs Rc'
se ter png
se out 'CvsRc.png'
rep
se term wxt
se xl 'Rc'
se yl 'S'
plot 'S.out' u 1:2 w l t 'S vs Rc'
se ter png
se out 'SvsRc.png'
rep
se term wxt

!

eog QvsRc.png
eog FvsRc.png
eog UvsRc.png
eog CvsRc.png
eog SvsRc.png