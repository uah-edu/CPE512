#!/bin/bash
module load mpich
srun --mpi=pmi2 ./heat_2d_loc_blk_MPI2_gnu 10000 5 S
# execute a 10000 x 10000 point 2d-heat transfer problem
# for 5 iternations and suppress its output

