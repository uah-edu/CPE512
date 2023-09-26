#!/bin/bash
#module load openmpi

mpic++ heat_2d_loc_blk_MPI.cpp -o heat_2d_loc_blk_MPI_gnu -O3
sleep 1

# mpirun -np 1 ./heat_2d_loc_blk_MPI_gnu 10 100 S
sleep 1
mpirun -np 2 ./heat_2d_loc_blk_MPI_gnu 10 100 S
sleep 1
mpirun -np 3 ./heat_2d_loc_blk_MPI_gnu 10 100 S
sleep 1
# mpirun -np 4 ./heat_2d_loc_blk_MPI_gnu 10 100 S
# sleep 1
# execute a 10000 x 10000 point 2d-heat transfer problem
# for 5 iternations and suppress its output

