#!/bin/bash
# ASC DMC
module load mpich
#
# 16 MPI Process Case
# This script executes the n x n point 2d-heat transfer problem 
# sweeping n from 1024 to 45,000 for a total of 9 runs.
# For each run, a total of 50 iterations is executed. The G 
# option causes the output data to be suppressed and the 
# execution time for each run to be outputed in a format
# that it can be used by the gnuplot application. Data is 
# plotted in textual format in x y format, where x
# is the value of n and y is the execution time in seconds. The
# output of each run is concatenated and placed in the file
# "heat_2d_snd_rcv_MPI_16_tm.txt" by the redirect operators 
# in this script.
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI  1024 50 G >  heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI  2048 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI  4096 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI  8192 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI 12288 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI 16384 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI 24576 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI 32768 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
srun --mpi=pmi2 ./heat_2d_snd_rcv_MPI 45000 50 G >> heat_2d_snd_rcv_MPI_16_tm.txt
