#!/bin/sh

module load gcc hpcx/2.17.1

./configure CFLAGS=-fopenmp CXXFLAGS=-fopenmp CC=mpicc CXX=mpicxx # --prefix=/home/pj24001725/ku40000061/non-blocking_mpi_benchmark/install_dir
make
# make install