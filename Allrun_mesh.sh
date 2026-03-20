#!/bin/bash

# OpenFOAM Overset Meshing Script per simulazione DRS in 2D
# lo scipt si esegue scrivendo sul terminale all'interno della cartella .../PROVA_3 bash ./Allrun_mesh.sh

# cd "${0%/*}" || exit

echo "==================== PULIZIA CASE ===================="
# Rimuove le vecchie mesh, i log e i file temporanei
find . -name "polyMesh" -type d -exec rm -rf {} +
find . -name "log.*" -type f -delete
find . -name "0" -type d -not -path "./0" -exec rm -rf {} +
find . -name "*.eMesh" -type f -delete

echo "==================== MESH MAIN BACKGROUND (RW) ===================="
cd RW_background
blockMesh
surfaceFeatureExtract
snappyHexMesh -overwrite > log.snappyHexMesh 2>&1
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
cd ..

# echo "==================== MESHING F1 ===================="
# cd F1
# blockMesh
# surfaceFeatureExtract
# snappyHexMesh -overwrite > log.snappyHexMesh 2>&1
# extrudeMesh > log.extrudeMesh 2>&1
# createPatch -overwrite
# # topoSet > log.topoSet 2>&1
# cd ..

# echo "==================== MESHING F2 ===================="
# cd F2
# blockMesh
# surfaceFeatureExtract
# snappyHexMesh -overwrite > log.snappyHexMesh 2>&1
# extrudeMesh > log.extrudeMesh 2>&1
# createPatch -overwrite
# # topoSet > log.topoSet 2>&1
# cd ..

echo "==================== MESHING U3 ===================="
cd U3
blockMesh
surfaceFeatureExtract
snappyHexMesh -overwrite > log.snappyHexMesh 2>&1
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
# topoSet > log.topoSet 2>&1
cd ..

echo "==================== MERGING MESHES ===================="
cd RW_background
# mergeMeshes . ../F1 -overwrite > log.mergeF1 2>&1
# mergeMeshes . ../F2 -overwrite > log.mergeF2 2>&1
mergeMeshes . ../U3 -overwrite > log.mergeU3 2>&1

topoSet > log.topoSet 2>&1
setFields
topoSet -dict system/topoSetDict_movingZone
overPimpleDyMFoam