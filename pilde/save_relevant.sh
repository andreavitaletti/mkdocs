#!/bin/bash

# Nome del file di input e cartella di destinazione
INPUT_FILE="image_paths.txt"
DEST_FOLDER="immagini"

# Creare la cartella di destinazione se non esiste
mkdir -p "$DEST_FOLDER"

# Leggere i percorsi dei file dal file di input
while IFS= read -r file_path; do
    if [[ -f "$file_path" ]]; then
        # Determinare il percorso relativo del file
        relative_path=$(dirname "$file_path")
        
        # Creare la struttura delle cartelle nella destinazione
        mkdir -p "$DEST_FOLDER/$relative_path"
        
        # Copiare il file mantenendo la struttura
        cp "$file_path" "$DEST_FOLDER/$relative_path"
        echo "Copiato: $file_path"
    else
        echo "File non trovato: $file_path"
    fi
done < "$INPUT_FILE"

