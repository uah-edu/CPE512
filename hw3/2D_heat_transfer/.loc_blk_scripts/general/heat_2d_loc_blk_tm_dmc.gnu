set output "heat_2d_loc_blk_tm_dmc.png"
set term png
set title "Execution Time, 2D Heat Transfer -- DMC (Loc. Block Comm.)"
set grid
set xrange[1024:45000]
set logscale x 2
set xlabel "n, Active Data Points in X and Y Dimension";
set ylabel "Execution Time in Seconds";
set key center top;
plot "heat_2d_serial_tm.txt" with linespoints t "Serial Ref","heat_2d_loc_blk_MPI_1_tm.txt" with linespoints t "1 MPI Procs","heat_2d_loc_blk_MPI_2_tm.txt" with linespoints t "2 MPI Procs","heat_2d_loc_blk_MPI_4_tm.txt" with linespoints t "4 MPI Procs", "heat_2d_loc_blk_MPI_8_tm.txt" with linespoints t "8 MPI Procs","heat_2d_loc_blk_MPI_16_tm.txt" with linespoints t "16 MPI Procs";
