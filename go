#!/bin/bash -l

if [ $# -ne 5 ]
then
  echo "wrong arguments"
  echo "usage: go <nodes> <npx> <npy> <npz> <nthreads>"
  exit
fi

nodes=$1
npx=$2
npy=$3
npz=$4
nth=$5

mpi=$((npx*npy*npz))
ppn=$((mpi/nodes))
echo "mpi:	$mpi"
echo "ppn:	$ppn"
pps=$((ppn/2))

ncore1=$((nodes*36))
ncore2=$((mpi*nth))

if [ $ncore1 -ne $ncore2 ]
then
  echo "error: ncore1=${ncore1} ncore2=${ncore2}"
  exit
fi

echo "nodes:	$nodes"
echo "npx:	$npx"
echo "npy:	$npy"
echo "npz:	$npz"
echo "nth:	$nth"

cat << EOF > job
#! /bin/bash
#PBS -l nodes=${nodes}:ppn=44
#PBS -l walltime=00:10:00
#PBS -V
#PBS -j oe
#PBS -N minighost

cd \$PBS_O_WORKDIR

export OMP_NUM_THREADS=${nth}

EXE=\${PWD}/source/miniGhost.x

aprun -n ${mpi} -N ${ppn} -S ${pps} -d ${nth} \${EXE} --npx ${npx} --npy ${npy} --npz ${npz} \
--scaling 1 --nx 672 --ny 672 --nz 672 --num_vars 40 --num_spikes 1 --debug_grid 1 --report_diffusion 21 --percent_sum 100 --num_tsteps 20 --stencil 24 --comm_method 10 --report_perf 1 --error_tol 8
EOF

qsub job
