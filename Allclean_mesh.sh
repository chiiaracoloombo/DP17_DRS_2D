#!/bin/bash
# OpenFOAM Cleaning Script per simulazione DRS in 2D
# lo scipt si esegue scrivendo sul terminale all'interno della cartella .../PROVA_3 bash ./Allclean_mesh.sh

# cd "${0%/*}" || exit

echo "==================== CLEANING CASE ===================="

# Pulizia di ciascuna cartella dei profili
for part in RW_background F1 F2 U3
do
    if [ -d "$part" ]; then
        echo "Pulizia cartella $part..."
        cd "$part"
        # Rimuove le mesh (tutto il contenuto di polyMesh) eccetto eventuali file base
        rm -rf constant/polyMesh
        # Rimuove le folder dei processori se il meshing/run era in parallelo
        rm -rf processor*
        # Rimuove i file di log generati dalla meshatura o running
        rm -f log.* log_*
        # Rimuove la cartella postProcessing
        rm -rf postProcessing
        # Rimuove tutte le cartelle dei temporal step (0.5, 1, ecc.) e lascia intatta la 0_org o la ricostruzione
        # Attenzione: Questo comando eliminerà anche la cartella '0' se viene generata! Se si vuole mantenere la '0'
        # non va inclusa. Di solito per la overset mesh temporanea non ci sono step del tempo.
        rm -rf 0.* [1-9]*
        
        # Torna indietro
        cd ..
    fi
done

# Puliamo alcuni file se serve anche all'esterno
rm -f log.*

echo "==================== COMPLETED CLEANING ===================="
