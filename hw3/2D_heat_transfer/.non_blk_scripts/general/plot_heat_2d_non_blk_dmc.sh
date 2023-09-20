#!/bin/bash
# script file to plot execution time and the other derived performance metrics
# of speedup, efficiency, and cost using gnuplot
# After ALL jobs have successfully executed this script can be applied
# Produces .png files which can be downloaded and viewed on client systems
sq=`squeue | wc -l`
if [ "$sq" -gt "1" ]
   then
   echo "Elements still in the SLURM Queue"
   echo "Need to clear SLURM Queue before creating plots"
   squeue
   exit
fi

# plot execution time
gnuplot ./heat_2d_non_blk_tm_dmc.gnu

#plot speedup using serial execution time as a reference
/home/shared/wells_class/.bin/gnu_sp heat_2d_serial_tm.txt heat_2d_non_blk_MPI_1_tm.txt  > heat_2d_non_blk_MPI_1_sp.txt
/home/shared/wells_class/.bin/gnu_sp heat_2d_serial_tm.txt heat_2d_non_blk_MPI_2_tm.txt  > heat_2d_non_blk_MPI_2_sp.txt
/home/shared/wells_class/.bin/gnu_sp heat_2d_serial_tm.txt heat_2d_non_blk_MPI_4_tm.txt  > heat_2d_non_blk_MPI_4_sp.txt
/home/shared/wells_class/.bin/gnu_sp heat_2d_serial_tm.txt heat_2d_non_blk_MPI_8_tm.txt  > heat_2d_non_blk_MPI_8_sp.txt
/home/shared/wells_class/.bin/gnu_sp heat_2d_serial_tm.txt heat_2d_non_blk_MPI_16_tm.txt > heat_2d_non_blk_MPI_16_sp.txt
gnuplot ./heat_2d_non_blk_sp_dmc.gnu

#plot efficiency using serial execution time as a reference and the specified number of processing cores
/home/shared/wells_class/.bin/gnu_ef heat_2d_serial_tm.txt heat_2d_non_blk_MPI_1_tm.txt 1  > heat_2d_non_blk_MPI_1_ef.txt
/home/shared/wells_class/.bin/gnu_ef heat_2d_serial_tm.txt heat_2d_non_blk_MPI_2_tm.txt 2 > heat_2d_non_blk_MPI_2_ef.txt
/home/shared/wells_class/.bin/gnu_ef heat_2d_serial_tm.txt heat_2d_non_blk_MPI_4_tm.txt 4 > heat_2d_non_blk_MPI_4_ef.txt
/home/shared/wells_class/.bin/gnu_ef heat_2d_serial_tm.txt heat_2d_non_blk_MPI_8_tm.txt 8 > heat_2d_non_blk_MPI_8_ef.txt
/home/shared/wells_class/.bin/gnu_ef heat_2d_serial_tm.txt heat_2d_non_blk_MPI_16_tm.txt 16 > heat_2d_non_blk_MPI_16_ef.txt
gnuplot ./heat_2d_non_blk_ef_dmc.gnu

#plot cost based on the parallel execution time and the specified number of processing cores
/home/shared/wells_class/.bin/gnu_cost heat_2d_non_blk_MPI_1_tm.txt  1 >  heat_2d_non_blk_MPI_1_ct.txt
/home/shared/wells_class/.bin/gnu_cost heat_2d_non_blk_MPI_2_tm.txt  2 >  heat_2d_non_blk_MPI_2_ct.txt
/home/shared/wells_class/.bin/gnu_cost heat_2d_non_blk_MPI_4_tm.txt  4 >  heat_2d_non_blk_MPI_4_ct.txt
/home/shared/wells_class/.bin/gnu_cost heat_2d_non_blk_MPI_8_tm.txt  8 >  heat_2d_non_blk_MPI_8_ct.txt
/home/shared/wells_class/.bin/gnu_cost heat_2d_non_blk_MPI_16_tm.txt 16 > heat_2d_non_blk_MPI_16_ct.txt
gnuplot ./heat_2d_non_blk_cost_dmc.gnu

