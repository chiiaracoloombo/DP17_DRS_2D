#!/bin/bash
# ==============================================================================
# Allclean.sh - Script di pulizia completa per simulazione DRS 2D con Overset
# Uso: eseguire da .../*percorso* con:  bash ./Allclean.sh
# ==============================================================================

# cd "${0%/*}" || exit

echo "==================== ALLCLEAN: PULIZIA COMPLETA ===================="

# Pulizia cartella background (mesh + risultati solver + postprocessing)
if [ -d "precursor" ]; then
    echo "  --> Pulizia mesh e risultati: precursor"
    cd precursor

    rm -rf constant/polyMesh

    rm -rf 0 0.* [1-9]*

    rm -rf processor* allProcessors

    rm -rf log_solve
    rm -f  log.* log_* *.log

    rm -rf postProcessing

    rm -rf VTK dynamicCode slices coefficients

    cd ..
fi

# Pulizia file di log nella cartella case
rm -f log.* log_* *.log

echo "==================== PULIZIA COMPLETATA ===================="