#!/bin/bash

# Inviter l'utilisateur à entrer la nouvelle valeur pour PLUGIN_NAME_HYPHEN
read -p "Entrez le nom du plugin (en minuscules et avec des tirets): " PLUGIN_NAME_HYPHEN

# Déduire PLUGIN_NAME_UNDERSCORE à partir de PLUGIN_NAME_HYPHEN
PLUGIN_NAME_UNDERSCORE=${PLUGIN_NAME_HYPHEN//-/_}

# Convertir en CamelCase pour les noms de classe
PLUGIN_NAME_CLASSCASE=$(echo "$PLUGIN_NAME_UNDERSCORE" | awk 'BEGIN{FS=OFS="_"} {for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1)) tolower(substr($i,2))} 1')

# Déduire PLUGIN_NAME_HYPHEN_UPPERCASE à partir de PLUGIN_NAME_HYPHEN
VersionConst="${PLUGIN_NAME_UNDERSCORE^^}_VERSION"

# Pré-remplir le chemin du plugin
# Inviter l'utilisateur à entrer la nouvelle valeur pour PLUGIN_NAME_HYPHEN
read -p "Entrez le nom du plugin (en minuscules et avec des tirets): " PLUGIN_NAME_HYPHEN

# Déduire PLUGIN_NAME_UNDERSCORE à partir de PLUGIN_NAME_HYPHEN
PLUGIN_NAME_UNDERSCORE=${PLUGIN_NAME_HYPHEN//-/_}

# Convertir en CamelCase pour les noms de classe
PLUGIN_NAME_CLASSCASE=$(echo "$PLUGIN_NAME_UNDERSCORE" | awk 'BEGIN{FS=OFS="_"} {for(i=1;i<=NF;i++)$i=toupper(substr($i,1,1)) tolower(substr($i,2))} 1')

# Déduire PLUGIN_NAME_HYPHEN_UPPERCASE à partir de PLUGIN_NAME_HYPHEN
VersionConst="${PLUGIN_NAME_UNDERSCORE^^}_VERSION"

# Pré-remplir le chemin du plugin
PLUGIN_DIR="./plugin-name"

# Chemin du fichier plugin-name.php
PLUGIN_FILE="$PLUGIN_DIR/plugin-name.php"

# Inviter l'utilisateur à entrer les nouvelles données pour le fichier plugin-name.php
read -p "Plugin Name: " PluginName
read -p "Plugin URI: " PluginURI
read -p "Description: " Description
read -p "Author: " Author
read -p "Author URI: " AuthorURI

# Obtenir l'URL du dépôt Git distant
gitRemoteUrl=$(git -C "$PLUGIN_DIR" remote get-url origin)

# Vérifier si l'URL du dépôt Git distant a été obtenue
if [[ -z "$gitRemoteUrl" ]]; then
    echo "Erreur : Impossible d'obtenir l'URL du dépôt Git distant."
    exit 1
fi

# Lire le contenu du fichier plugin-name.php
Content=$(cat "$PLUGIN_FILE")

# Remplacer les anciennes données par les nouvelles données
Content=$(echo "$Content" | \
    sed -e "s|WordPress Plugin Boilerplate|$PluginName|g" \
        -e "s|http://example.com/plugin-name-uri/|$PluginURI|g" \
        -e "s|This is a short description of what the plugin does. It's displayed in the WordPress admin area.|$Description|g" \
        -e "s|Your Name or Your Company|$Author|g" \
        -e "s|http://example.com/|$AuthorURI|g" \
        -e "s|(?<=@link\s).*|$gitRemoteUrl|g" \
        -e "s|PLUGIN_NAME_VERSION|$VersionConst|g")

# Écrire le nouveau contenu dans le fichier plugin-name.php
echo "$Content" > "$PLUGIN_FILE"

# Fonction pour renommer les fichiers

# Chemin du fichier plugin-name.php
PLUGIN_FILE="$PLUGIN_DIR/plugin-name.php"

# Inviter l'utilisateur à entrer les nouvelles données pour le fichier plugin-name.php
read -p "Plugin Name: " PluginName
read -p "Plugin URI: " PluginURI
read -p "Description: " Description
read -p "Author: " Author
read -p "Author URI: " AuthorURI

# Obtenir l'URL du dépôt Git distant
gitRemoteUrl=$(git -C "$PLUGIN_DIR" remote get-url origin)

# Vérifier si l'URL du dépôt Git distant a été obtenue
if [[ -z "$gitRemoteUrl" ]]; then
    echo "Erreur : Impossible d'obtenir l'URL du dépôt Git distant."
    exit 1
fi

# Lire le contenu du fichier plugin-name.php
Content=$(cat "$PLUGIN_FILE")

# Remplacer les anciennes données par les nouvelles données
Content=$(echo "$Content" | \
    sed -e "s|WordPress Plugin Boilerplate|$PluginName|g" \
        -e "s|http://example.com/plugin-name-uri/|$PluginURI|g" \
        -e "s|This is a short description of what the plugin does. It's displayed in the WordPress admin area.|$Description|g" \
        -e "s|Your Name or Your Company|$Author|g" \
        -e "s|http://example.com/|$AuthorURI|g" \
        -e "s|(?<=@link\s).*|$gitRemoteUrl|g" \
        -e "s|PLUGIN_NAME_VERSION|$VersionConst|g")

# Écrire le nouveau contenu dans le fichier plugin-name.php
echo "$Content" > "$PLUGIN_FILE"

# Fonction pour renommer les fichiers
rename_files() {
    local directory=$1
    find "$directory" -type f -name "*plugin-name*" | while read -r file; do
        mv "$file" "${file//plugin-name/$PLUGIN_NAME_HYPHEN}"
    local directory=$1
    find "$directory" -type f -name "*plugin-name*" | while read -r file; do
        mv "$file" "${file//plugin-name/$PLUGIN_NAME_HYPHEN}"
    done
}

# Fonction pour remplacer le texte dans les fichiers
replace_text() {
    local directory=$1
    find "$directory" -type f | while read -r file; do
        sed -i \
            -e "s|plugin_name|$PLUGIN_NAME_UNDERSCORE|g" \
            -e "s|plugin-name|$PLUGIN_NAME_HYPHEN|g" \
            -e "s|Plugin_Name|$PLUGIN_NAME_CLASSCASE|g" \
            "$file"
    done
    local directory=$1
    find "$directory" -type f | while read -r file; do
        sed -i \
            -e "s|plugin_name|$PLUGIN_NAME_UNDERSCORE|g" \
            -e "s|plugin-name|$PLUGIN_NAME_HYPHEN|g" \
            -e "s|Plugin_Name|$PLUGIN_NAME_CLASSCASE|g" \
            "$file"
    done
}

# Appeler les fonctions
rename_files "$PLUGIN_DIR"
replace_text "$PLUGIN_DIR"

# Renommer le dossier du plugin
mv "$PLUGIN_DIR" "${PLUGIN_DIR//plugin-name/$PLUGIN_NAME_HYPHEN}"

rename_files "$PLUGIN_DIR"
replace_text "$PLUGIN_DIR"

# Renommer le dossier du plugin
mv "$PLUGIN_DIR" "${PLUGIN_DIR//plugin-name/$PLUGIN_NAME_HYPHEN}"
