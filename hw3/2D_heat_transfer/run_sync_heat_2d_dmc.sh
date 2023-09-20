#!/bin/bash
# This script calls the run_script_mpi utility six times to schedule 
# the serial reference simulation and the five other multi-process MPI
# simulations (1, 2, 4, 8, and 16 MPI process) that utilize synchronous
# point-to-point communication routines for the ghost-point communications.
# The script requests the number of processing nodes to equal the number
# of processes that are to be executed on the dmc 
#
# Re-compile source files (serial & MPI)
# Re-compiling Reference Source File
if test -f "./heat_2d_serial.cpp" 
  then
  echo "Recompiling Reference Serial Source file heat_2d_serial.cpp"
  echo "g++ heat_2d_serial.cpp -o heat_2d_serial -std=c++11 -O3"
  g++ heat_2d_serial.cpp -o heat_2d_serial -std=c++11 -O3
  echo "complete!"
else
  if test -f "./heat_2d_serial.c" 
    then
    echo "Recompiling Source file heat_2d_serial.c"
    echo "gcc heat_2d_serial.c -o heat_2d_serial -O3"
    mpicc heat_2d_serial.c -o heat_2d_serial -O3
    echo "complete!"
  else
    echo "No valid serial source file found!"
    echo "Looking for file heat_2d_serial.cpp, or heat_2d_serial.c"
    echo "to compile"
    exit
  fi  
fi  
# Re-compiling MPI Source File
if test -f "./heat_2d_sync_MPI.cpp" 
  then
  echo "Recompiling Source file heat_2d_sync_MPI.cpp"
  echo "mpic++ heat_2d_sync_MPI.cpp -o heat_2d_sync_MPI -std=c++11 -O3"
  module load openmpi
  mpic++ heat_2d_sync_MPI.cpp -o heat_2d_sync_MPI -std=c++11 -O3
  echo "complete!"
  # copy mpi scripts to the current directory
  echo "Copying openmpi script files to current directory"
  cp /home/shared/wells_class/MPI_Examples/2D_heat_transfer/.sync_scripts/openmpi/* . 
else
  if test -f "./heat_2d_sync_MPI2.cpp" 
    then
    echo "Recompiling Source file heat_2d_sync_MPI2.cpp"
    echo "mpic++ heat_2d_sync_MPI2.cpp -o heat_2d_sync_MPI -std=c++11 -O3"
    module load mpich
    mpic++ heat_2d_sync_MPI2.cpp -o heat_2d_sync_MPI -std=c++11 -O3
    echo "complete!"
    # copy mpi scripts to the current directory
    echo "Copying mpich script files to current directory"
    cp /home/shared/wells_class/MPI_Examples/2D_heat_transfer/.sync_scripts/mpich/* . 
  else
    if test -f "./heat_2d_sync_MPI.c" 
      then
      echo "Recompiling Source file heat_2d_sync_MPI.c"
      echo "mpicc heat_2d_sync_MPI.c -o heat_2d_sync_MPI -O3"
      module load openmpi
      mpicc heat_2d_sync_MPI.c -o heat_2d_sync_MPI -O3
      echo "complete!"
      # copy mpi scripts to the current directory
      echo "Copying openmpi script files to current directory"
      cp /home/shared/wells_class/MPI_Examples/2D_heat_transfer/.sync_scripts/openmpi/* . 
    else
      echo "No valid source file found!"
      echo "Looking for file heat_2d_sync_MPI.cpp, heat_2d_sync_MPI2.cpp"
      echo "or heat_2d_sync_MPI.c to compile"
      exit
    fi  
  fi  
fi  
# copy general scripts to the current directory
echo "Copying plot scripting files to current directory"
cp /home/shared/wells_class/MPI_Examples/2D_heat_transfer/.sync_scripts/general/* . 

# Check for script run time arch constraint parameter
if test $# -ne 0
  then
  constraint=$1
else
  constraint="ivy-bridge"
fi
echo "Architectural Constraint: "$constraint
echo

# Serial Reference Run
# Number of Nodes: 1 
# Script File: heat_2d_serial_tm.txt
echo -e "Scheduling Serial Job on the DMC\n"
echo -e "class\n1\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_serial_dmc.sh >heat_2d_serial_tm.txt
#
# 1 MPI Process Run
# Number of Nodes: 1 
# Script File: heat_2d_sync_MPI_1_tm.txt
echo -e "Scheduling 1 MPI Process Job on the DMC\n"
echo -e "class\n1\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_sync_MPI_1_dmc.sh >heat_2d_sync_MPI_1_tm.txt
#
# 2 MPI Process Run
# Number of Nodes: 2 
# Script File: heat_2d_sync_MPI_2_tm.txt
echo -e "Scheduling 2 MPI Process Job on the DMC\n"
# DMC Node Architecture Constraint: first argument
echo -e "class\n2\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_sync_MPI_2_dmc.sh >heat_2d_sync_MPI_2_tm.txt
#
# 4 MPI Process Run
# Number of Nodes: 4 
# Script File: heat_2d_sync_MPI_4_tm.txt
echo -e "Scheduling 4 MPI Process Job on the DMC\n"
echo -e "class\n4\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_sync_MPI_4_dmc.sh >heat_2d_sync_MPI_4_tm.txt
#
# 8 MPI Process Run
# Number of Nodes: 8 
# Script File: heat_2d_sync_MPI_8_tm.txt
echo -e "Scheduling 8 MPI Process Job on the DMC\n"
echo -e "class\n8\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_sync_MPI_8_dmc.sh >heat_2d_sync_MPI_8_tm.txt
#
# 16 MPI Process Run
# Number of Nodes: 16 
# Script File: heat_2d_sync_MPI_16_tm.txt
echo -e "Scheduling 16 MPI Process Job on the DMC\n"
echo -e "class\n16\n01:00:00\n32gb\n\n"$constraint"\n" | run_script_mpi heat_2d_sync_MPI_16_dmc.sh >heat_2d_sync_MPI_16_tm.txt

