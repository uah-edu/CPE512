set output "heat_2d_non_blk_cost_dmc.png"
set term png
set title "Time Costs, 2D Heat Transfer -- DMC (Asynchronous Comm.)"
set grid
set xrange [1024:45000]
set logscale x 2
set xlabel "n, Active Data Points in X and Y Dimension";
set ylabel "Time Cost in Aggregate Seconds";
set key left top;
plot "heat_2d_non_blk_MPI_1_ct.txt" with linespoints t "1 MPI Procs","heat_2d_non_blk_MPI_2_ct.txt" with linespoints t "2 MPI Procs","heat_2d_non_blk_MPI_4_ct.txt" with linespoints t "4 MPI Procs", "heat_2d_non_blk_MPI_8_ct.txt" with linespoints t "8 MPI Procs","heat_2d_non_blk_MPI_16_ct.txt" with linespoints t "16 MPI Procs";
