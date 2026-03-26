#!/bin/bash
# OpenFOAM Run Solver Script per simulazione DRS in 2D 

# cd "${0%/*}" || exit

echo "==================== STARTING SOLVER FOR SIMULATION ===================="

# Il calcolo avviene nella cartella RW_background 
cd RW_background

splitMeshRegions
rm -rf 1e-05
topoSet > log.topoSet 2>&1
cp -rf ./orig0/* ./0/
topoSet -dict system/topoSetDict_movingZone > log.topoSet 2>&1

setFields

mapFields ../precursor/ -sourceTime 'latestTime'


renumberMesh -overwrite

overPimpleDyMFoam

echo "==================== SIMULATION FINISHED ===================="