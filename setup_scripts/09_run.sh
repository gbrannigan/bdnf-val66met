#!/bin/bash
#SBATCH --partition=large
#SBATCH --qos=large-award
##SBATCH --gres=gpu:2
#SBATCH --job-name=V_hid_11              # Assign an 8-character name to your job
#SBATCH -N 64 --tasks-per-node=36
#SBATCH --time=48:00:00                 # Total run time limit (HH:MM:SS)
#SBATCH --output=slurm.out        # combined STDOUT and STDERR output file
##SBATCH --output=tom_no_e.out        # combined STDOUT and STDERR output file
#SBATCH --export=ALL                    # Export you current env to the job env
##SBATCH --dependency=afterok:1617523

#set -e
set echo
module load openmpi/1.10.4
export GMX_NSTLIST=20
export GMX_MAXBACKUP=-1


#export GMX_DISABLE_SIMD_KERNELS=1
module list
GRO=/home1/rl487/software/gromacs-5.1.2/bin/gmx_mpi
(for i in {0..63} ; do cd $i ; cp ex.cpt ex_$SLURM_JOBID.cpt ; cd .. ; done )
(for i in {0..63} ; do cd $i ; cp ex_prev.cpt ex_prev_$SLURM_JOBID.cpt ; cd .. ; done )
mpirun -np $SLURM_NTASKS $GRO mdrun -deffnm ex -multidir {0..63} -v -noappend -replex 500 -cpi ex.cpt -notunepme -nstlist 20 -maxh 47
