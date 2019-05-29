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

#more rep_06 | grep Vol | awk '{ sum += $2; n++ } END { if (n > 0) print sum / n; }'
#took replica 28 box size, closest to the avg vol 
(echo 22 > m ; for i in {0..63} ; do cd $i ; ibrun -np 1 gmx energy -f npt.part0001.edr -xvg no -b 4000 < ../m ; awk '{print $1,$2}' energy.xvg | sort -k2 | head -n 1| awk '{print $1}' > a; echo $a ; cd .. ; done )  &&\ #time frame for smallest average volume after 4ns of equilibration
(echo 0 > m ; for i in {0..63} ; do cd $i ; ibrun -np 1 gmx trjconv -f npt.part0001.xtc -pbc whole -s nvt.tpr -dump $(cat a) -o vol.gro < ../m ; cd  .. ; done ) && \
( for i in {0..63}; do cd $i ; ibrun -np 1 gmx editconf -f vol.gro -o eq_vol.gro -box 10.97 -bt dodecahedron -c >& editconf_vol.out ; cd .. ; done 
)

