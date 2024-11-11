#!/bin/sh
#PJM -L rscgrp=a-batch
#PJM -L elapse=0:30:00
#PJM -L node=8

module load gcc hpcx/2.17.1

export OMP_NUM_THREADS=120

echo "no sharp HPC-X"
mpirun -n 8 --map-by ppr:1:node -mca btl_openib_if_include mlx5_0:1  \
-x LD_LIBRARY_PATH /home/pj24001725/ku40000061/OSU_micro_benchmarks/c/mpi/collective/non_blocking/osu_iallreduce \
-i 10 -x 10 -m 8

echo "sharp HPC-X"
mpirun -n 8 \
--map-by ppr:1:node \
-mca btl_openib_if_include mlx5_0:1 \
-mca coll_hcoll_enable 0 -mca coll_ucc_enable 1 \
-x OMPI_UCC_CL_BASIC_TLS=ucp,sharp \
-x SHARP_COLL_ENABLE_SAT=1 \
-x SHARP_COLL_LOG_LEVEL=3 \
-x HCOLL_MAIN_IB=mlx5_0:1 \
-x UCX_NET_DEVICES=mlx5_0:1 \
-x LD_LIBRARY_PATH /home/pj24001725/ku40000061/OSU_micro_benchmarks/c/mpi/collective/non_blocking/osu_iallreduce \
-i 10 -x 10 -m 8

#build MVAPICH
module purge
module load gcc
# make clean
MPIDIR=/home/tmp/ku40000114/local/mvapich/3.0-gcc8.5.0-sharp3.5.1
export PATH=${MPIDIR}/bin:${PATH}
export LD_LIBRARY_PATH=${MPIDIR}/lib:${LD_LIBRARY_PATH}

# ./configure CFLAGS=-fopenmp CXXFLAGS=-fopenmp CC=mpicc CXX=mpicxx
# make -j 32

echo "progress thread MVAPICH"

# Without Progress Thread
# export MPICH_ASYNC_PROGRESS=0
# mpiexec -np 8 -ppn 2 -machinefile ${PJM_O_NODEINF} -launcher ssh -launcher-exec /bin/pjrsh c/mpi/collective/non_blocking/osu_iallreduce -Tmpi_float >& log.normal

# With Progress Thread
export MPICH_ASYNC_PROGRESS=1
export OMP_NUM_THREADS=119
mpiexec -np 8 -ppn 1 -machinefile ${PJM_O_NODEINF} -launcher ssh -launcher-exec /bin/pjrsh \
/home/pj24001725/ku40000061/OSU_micro_benchmarks/c/mpi/collective/non_blocking/osu_iallreduce -Tmpi_float -i 10 -x 10 -m 8