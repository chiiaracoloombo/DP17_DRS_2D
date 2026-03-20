#!/bin/bash
set -e
NP=12

# OpenFOAM Overset Parallel Meshing Script per simulazione DRS in 2D
# lo scipt si esegue scrivendo sul terminale all'interno della cartella .../PROVA_3 bash ./Allrun_mesh_par.sh

echo "==================== PULIZIA CASE ===================="
find . -name "polyMesh" -type d -exec rm -rf {} +
find . -name "log.*" -type f -delete
find . -name "0" -type d -not -path "./0" -exec rm -rf {} +
find . -name "*.eMesh" -type f -delete
find . -name "processor*" -type d -exec rm -rf {} +

echo "==================== MESH MAIN BACKGROUND (RW) ===================="
cd RW_background
blockMesh
surfaceFeatureExtract
decomposePar > log.decomposePar 2>&1
mpirun -np $NP --oversubscribe snappyHexMesh -parallel -overwrite > log.snappyHexMesh 2>&1
reconstructParMesh -constant > log.reconstructParMesh 2>&1
rm -rf processor*
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
cd ..

echo "==================== MESHING F1 ===================="
cd F1
blockMesh
surfaceFeatureExtract
decomposePar > log.decomposePar 2>&1
mpirun -np $NP --oversubscribe snappyHexMesh -parallel -overwrite > log.snappyHexMesh 2>&1
reconstructParMesh -constant > log.reconstructParMesh 2>&1
rm -rf processor*
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
topoSet > log.topoSet 2>&1
cd ..

echo "==================== MESHING F2 ===================="
cd F2
blockMesh
surfaceFeatureExtract
decomposePar > log.decomposePar 2>&1
mpirun -np $NP --oversubscribe snappyHexMesh -parallel -overwrite > log.snappyHexMesh 2>&1
reconstructParMesh -constant > log.reconstructParMesh 2>&1
rm -rf processor*
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
topoSet > log.topoSet 2>&1
cd ..

echo "==================== MESHING U3 ===================="
cd U3
blockMesh
surfaceFeatureExtract
decomposePar > log.decomposePar 2>&1
mpirun -np $NP --oversubscribe snappyHexMesh -parallel -overwrite > log.snappyHexMesh 2>&1
reconstructParMesh -constant > log.reconstructParMesh 2>&1
rm -rf processor*
extrudeMesh > log.extrudeMesh 2>&1
createPatch -overwrite
topoSet > log.topoSet 2>&1
cd ..

echo "==================== MERGING MESHES ===================="
cd RW_background
mergeMeshes . ../F1 -overwrite > log.mergeF1 2>&1
mergeMeshes . ../F2 -overwrite > log.mergeF2 2>&1
mergeMeshes . ../U3 -overwrite > log.mergeU3 2>&1
cd ..

echo "Meshing process finished!"