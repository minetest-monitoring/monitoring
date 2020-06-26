set grid
set datafile separator ","
set term png
set output 'data.png'
set timefmt '%Y-%m-%d_%H:%M:%S'
set xdata time
plot 'data.csv' using 0:1 w lines
