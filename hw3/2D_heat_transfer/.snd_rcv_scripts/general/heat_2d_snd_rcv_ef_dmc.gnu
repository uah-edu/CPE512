set output "heat_2d_snd_rcv_ef_dmc.png"
set term png
set title "Efficiency, 2D Heat Transfer, DMC, (MPIsendrecv Comm.)"
set grid
set xrange [1024:45000]
set logscale x 2
set xlabel "n, Active Data Points in X and Y Dimension";
set ylabel "Efficiency";
set key right bottom;
plot "heat_2d_snd_rcv_MPI_1_ef.txt" with linespoints t "1 MPI Procs","heat_2d_snd_rcv_MPI_2_ef.txt" with linespoints t "2 MPI Procs","heat_2d_snd_rcv_MPI_4_ef.txt" with linespoints t "4 MPI Procs", "heat_2d_snd_rcv_MPI_8_ef.txt" with linespoints t "8 MPI Procs","heat_2d_snd_rcv_MPI_16_ef.txt" with linespoints t "16 MPI Procs";
