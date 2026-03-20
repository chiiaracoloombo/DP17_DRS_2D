#!/bin/bash
# ==============================================================================
# Allclean.sh - Script di pulizia completa per simulazione DRS 2D con Overset
# Uso: eseguire da .../*percorso* con:  bash ./Allclean.sh
# ==============================================================================

# cd "${0%/*}" || exit

echo "==================== ALLCLEAN: PULIZIA COMPLETA ===================="

# Pulizia cartelle dei profili overset (mesh + logs)
for part in F1 F2 U3
do
    if [ -d "$part" ]; then
        echo "  --> Pulizia mesh e log: $part"
        cd "$part"
        rm -rf constant/polyMesh
        rm -rf processor*
        rm -rf postProcessing
        rm -rf 0.* [1-9]*
        rm -f  log.* log_* *.log
        cd ..
    fi
done

# Pulizia cartella background (mesh + risultati solver + postprocessing)
if [ -d "RW_background" ]; then
    echo "  --> Pulizia mesh e risultati: RW_background"
    cd RW_background

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