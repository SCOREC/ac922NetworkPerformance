set terminal png size 800,600 enhanced font "20"
set output 'allreduceLassen.png'
set datafile separator ","
set logscale x
set logscale y
set xlabel "message size (B)"
set ylabel "time (us)"
set title "Lassen AllReduce Latency"
p for [col=2:7] 'all.csv' using 1:col with lp t col
