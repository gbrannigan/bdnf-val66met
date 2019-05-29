#!/bin/bash
#calls vmd script to mutate residue 66
echo exit > exit
for i in {0..63}
do
cd $i
vmd -e ../selection_mutate.pgn >& psf_mutate.out < ../exit
sed 's/CAY/CH3/;s/CAT/CH3/;;' pre-resid_23-113-capped.pdb > resid_23-113-capped.pdb
cd ..
done
