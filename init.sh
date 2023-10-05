#!/bin/bash

# Chemin du dossier du plugin
PLUGIN_DIR="./plugin-name"
PLUGIN_NAME_HYPHEN="boat-mini-game"
PLUGIN_NAME_UNDERSCORE="boat_mini_game"
onction pour renommer les fichiers

rename_files() {
    find $1 -type f -name "*plugin-name*" | while read FILE ; do
        newfile="$(echo ${FILE} | sed -e "s/plugin-name/${PLUGIN_NAME_HYPHEN}/g")" ;
        mv "${FILE}" "${newfile}" ;
    done
}

# Fonction pour remplacer le texte dans les fichiers
replace_text() {
    find $1 -type f -exec sed -i '' -e "s/plugin_name/${PLUGIN_NAME_UNDERSCORE}/g" {} +
    find $1 -type f -exec sed -i '' -e "s/plugin-name/${PLUGIN_NAME_HYPHEN}/g" {} +
    # ... autres remplacements
}

# Appeler les fonctions
rename_files $PLUGIN_DIR
replace_text $PLUGIN_DIR