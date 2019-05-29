#!/bin/bash
#SBATCH -J V4           # job name
#SBATCH -o stam.out       # output and error file name (%j expands to jobID)
#SBATCH -n 1          # total number of mpi tasks requested
#SBATCH -p normal         # queue (partition) -- normal, development, etc.
#SBATCH -t 00:30:00        # run time (hh:mm:ss) - 1.5 hours
##SBATCH --mail-user=ruchi15@gmail.com       
##SBATCH --mail-type=begin  # email me when the job starts
##SBATCH --mail-type=end    # email me when the job finishes

#set -x
module purge
module load intel/15.0.2
module load mvapich2/2.1
module load boost
module load gromacs/5.1.2
module list
export GMX_MAXBACKUP=-1

echo "13" > ../inp

#writes the volume of each replcia in one file 

rm -rf rep_06
( for i in {0..63} ; do cd $i ;ibrun -np 1 gmx energy -f npt.part0001.edr -b 50 < ../v >& avg_vol ; cd .. ; done )
( for i in {0..63} ; do cd $i ; more avg_vol | grep 'Pressure                 \|Volume                      ' >> ../rep_06 ; echo $i >> ../rep_06 ; cd .. ; done )
