#!/bin/bash
# OpenFOAM Run Solver Script per simulazione DRS in 2D 

# cd "${0%/*}" || exit

echo "==================== STARTING SOLVER FOR SIMULATION ===================="

# Il calcolo avviene nella cartella RW_background 
cd RW_background

echo "==================== CLEAN TIMESTEPS & LOGS ===================="
rm -rf [1-9]* processor* log_solve postProcessing VTK allProcessors
rm -rf 0

cp -r system/orig0 0

mkdir -p log_solve

echo "==================== SET FIELDS ===================="
# setFields popola il campo zoneID basandosi sul setFieldsDict [cite: 13, 15]
setFields > log_solve/00_setFields 2>&1

# ================================================================
# Estrazione pulita di np: rimuove ';', spazi e caratteri invisibili 
np=$(grep 'np' ../initialConditions | awk '{print $2}' | tr -d '; \r\n\t')
if [ -z "$np" ]; then
    np=12 
fi
echo "Numero di core rilevato: $np"
# ================================================================

echo "==================== DECOMPOSE PAR ===================="
# Decompone la mesh per il calcolo parallelo [cite: 27]
decomposePar > log_solve/01_decomposePar 2>&1

# Aggiunto --oversubscribe per forzare l'uso dei 12 core richiesti [cite: 2]
echo "==================== RENUMBER MESH ===================="
mpirun -np $np --oversubscribe renumberMesh -overwrite -parallel > log_solve/02_renumberMesh 2>&1

echo "==================== OVERPIMPLEDYMFOAM ===================="
mpirun -np $np --oversubscribe overPimpleDyMFoam -parallel > log_solve/04_overPimpleDyMFoam 2>&1

echo "==================== POSTPROCESSING ===================="
mpirun -np $np --oversubscribe postProcess -func "Lambda2" -parallel > log_solve/06_Lambda2 2>&1
mpirun -np $np --oversubscribe postProcess -func "mag(vorticity)" -parallel > log_solve/08_magVorticity 2>&1

echo "==================== RECONSTRUCT ===================="
# Ricostruisce la mesh e i campi dai processori [cite: 10]
reconstructPar > log_solve/10_reconstructPar 2>&1
reconstructPar -fields '(phi)' > log_solve/11_reconstructPar0 2>&1

echo "==================== ZIP PROCESSORS ===================="
mkdir -p allProcessors
mv processor* ./allProcessors

cd ..
echo "==================== SIMULATION FINISHED ===================="