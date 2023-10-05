# Inviter l'utilisateur à entrer la nouvelle valeur pour $PLUGIN_NAME_HYPHEN
$PLUGIN_NAME_HYPHEN = Read-Host -Prompt "Entrez le nom du plugin (en minuscules et avec des tirets)"

# Déduire $PLUGIN_NAME_UNDERSCORE à partir de $PLUGIN_NAME_HYPHEN
$PLUGIN_NAME_UNDERSCORE = $PLUGIN_NAME_HYPHEN -replace "-", "_"

$PLUGIN_NAME_CLASSCASE = (Get-Culture).TextInfo.ToTitleCase($PLUGIN_NAME_UNDERSCORE.ToLower())

# Déduire $PLUGIN_NAME_HYPHEN_UPPERCASE à partir de $PLUGIN_NAME_HYPHEN
$VersionConst = $PLUGIN_NAME_UNDERSCORE.ToUpper() + "_VERSION"

# Pré-remplir le chemin du plugin
$PLUGIN_DIR = "./plugin-name"

# Chemin du fichier plugin-name.php
$PLUGIN_FILE = "$PLUGIN_DIR/plugin-name.php"

# # Inviter l'utilisateur à entrer les nouvelles données pour le fichier plugin-name.php
$PluginName = Read-Host -Prompt "Plugin Name"
$PluginURI = Read-Host -Prompt "Plugin URI"
$Description = Read-Host -Prompt "Description"
$Author = Read-Host -Prompt "Author"
$AuthorURI = Read-Host -Prompt "Author URI"

# # Obtenir l'URL du dépôt Git distant
$gitRemoteUrl = git -C $PLUGIN_DIR remote get-url origin

# # Vérifier si l'URL du dépôt Git distant a été obtenue
if (-not $gitRemoteUrl) {
    Write-Host "Erreur : Impossible d'obtenir l'URL du dépôt Git distant."
    exit 1
}

# # Lire le contenu du fichier plugin-name.php
$Content = Get-Content -Path $PLUGIN_FILE

# # Remplacer les anciennes données par les nouvelles données
$Content = $Content -replace "WordPress Plugin Boilerplate", $PluginName `
    -replace "http://example.com/plugin-name-uri/", $PluginURI `
    -replace "This is a short description of what the plugin does. It's displayed in the WordPress admin area.", $Description `
    -replace "Your Name or Your Company", $Author `
    -replace "http://example.com/", $AuthorURI `
    -replace '(?<=@link\s).*', $gitRemoteUrl `
    -replace "PLUGIN_NAME_VERSION", $VersionConst

# # Écrire le nouveau contenu dans le fichier plugin-name.php
$Content | Out-File -FilePath $PLUGIN_FILE

# Fonction pour renommer les fichiers
Function Rename-Files {
    Param (
        [string]$directory
    )
    Get-ChildItem -Path $directory -Recurse -File | Where-Object { $_.Name -match "plugin-name" } | ForEach-Object {
        $newName = $_.Name -replace "plugin-name", $PLUGIN_NAME_HYPHEN
        Rename-Item -Path $_.FullName -NewName $newName
    }
}

# Function to replace text in files
Function Replace-Text {
    Param (
        [string]$directory
    )
    Get-ChildItem -Path $directory -Recurse -File | ForEach-Object {
        $filePath = $_.FullName
        try {
            # Read the entire file content at once
            $content = Get-Content $filePath -Raw -Encoding UTF8

            # Replace text using the [regex]::Replace method for case-sensitive replacement
            $content = [regex]::Replace($content, 'plugin_name', $PLUGIN_NAME_UNDERSCORE)
            $content = [regex]::Replace($content, 'plugin-name', $PLUGIN_NAME_HYPHEN)
            $content = [regex]::Replace($content, 'Plugin_Name', $PLUGIN_NAME_CLASSCASE)

            # Write the modified content back to the file
            $content | Set-Content $filePath -Encoding UTF8
        }
        catch {
            Write-Host "Error: $_"
        }
    }
}

# Appeler les fonctions
Rename-Files -directory $PLUGIN_DIR
Replace-Text -directory $PLUGIN_DIR

# Renommer le dossier du plugin
$NewPluginDir = $PLUGIN_DIR -replace "plugin-name", $PLUGIN_NAME_HYPHEN
Rename-Item -Path $PLUGIN_DIR -NewName $NewPluginDir