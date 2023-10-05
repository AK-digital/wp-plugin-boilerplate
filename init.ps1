# Invite the user to enter the new value for $PLUGIN_NAME_HYPHEN
do {
    $PLUGIN_NAME_HYPHEN = Read-Host -Prompt "Enter the plugin name (in lowercase, without spaces and with hyphens)"
    if ($PLUGIN_NAME_HYPHEN -cmatch '[A-Z]' -or $PLUGIN_NAME_HYPHEN -match '\s') {
        $PLUGIN_NAME_HYPHEN = $null  # Réinitialiser la valeur pour que la boucle continue
        Write-Host "Error : Unauthorized characters or spaces."
    }
} while ([string]::IsNullOrWhiteSpace($PLUGIN_NAME_HYPHEN) -or $PLUGIN_NAME_HYPHEN -notmatch '^[a-z0-9-]+$')


# Derive $PLUGIN_NAME_UNDERSCORE from $PLUGIN_NAME_HYPHEN
$PLUGIN_NAME_UNDERSCORE = $PLUGIN_NAME_HYPHEN -replace "-", "_"

$PLUGIN_NAME_CLASSCASE = (Get-Culture).TextInfo.ToTitleCase($PLUGIN_NAME_UNDERSCORE.ToLower())

# Derive $PLUGIN_NAME_CLASSCASE from $PLUGIN_NAME_UNDERSCORE
$VersionConst = $PLUGIN_NAME_UNDERSCORE.ToUpper() + "_VERSION"

# Pre-fill the plugin path
$PLUGIN_DIR = "./plugin-name"

# Path of the file plugin-name.php
$PLUGIN_FILE = "$PLUGIN_DIR/plugin-name.php"

# Invite the user to enter the new data for the file plugin-name.php
do {
    $PluginName = Read-Host -Prompt "Plugin Name (required)"
} while ([string]::IsNullOrWhiteSpace($PluginName))
$PluginURI = Read-Host -Prompt "Plugin URI"
$Description = Read-Host -Prompt "Description"
$Author = Read-Host -Prompt "Author"
$AuthorURI = Read-Host -Prompt "Author URI"
$License = Read-Host -Prompt "License (default is GPL-2.0-or-later)"
if ([string]::IsNullOrWhiteSpace($License)) {
    $License = "GPL-2.0-or-later"
}
$LicenseURI = Read-Host -Prompt "License URI (default is https://www.gnu.org/licenses/gpl-2.0.html)"
if ([string]::IsNullOrWhiteSpace($License)) {
    $License = "https://www.gnu.org/licenses/gpl-2.0.html"
}

# Obtain the URL of the remote Git repository
$gitRemoteUrl = git -C $PLUGIN_DIR remote get-url origin

# Check if the URL of the remote Git repository has been obtained
if (-not $gitRemoteUrl) {
    $gitRemoteUrl = ""
}

# Read the content of the file plugin-name.php
$Content = Get-Content -Path $PLUGIN_FILE

# Replace the old data with the new data
$Content = $Content -replace "WordPress Plugin Boilerplate", $PluginName `
    -replace "http://example.com/plugin-name-uri/", $PluginURI `
    -replace "This is a short description of what the plugin does. It's displayed in the WordPress admin area.", $Description `
    -replace "Your Name or Your Company", $Author `
    -replace "http://example.com/", $AuthorURI `
    -replace '(?<=@link\s).*', $gitRemoteUrl `
    -replace "GPL-2.0+", $License `
    -replace "http://www.gnu.org/licenses/gpl-2.0.txt", $LicenseURI `
    -replace "PLUGIN_NAME_VERSION", $VersionConst

# Write the new content in the file plugin-name.php
$Content | Out-File -FilePath $PLUGIN_FILE

# Function to rename files
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

            # Check if content is null or empty before proceeding
            if ([string]::IsNullOrWhiteSpace($content)) {
                Write-Host "Warning: File $filePath is empty or inaccessible."
            } else {
                # Replace text using the [regex]::Replace method for case-sensitive replacement
                $content = [regex]::Replace($content, 'plugin_name', $PLUGIN_NAME_UNDERSCORE)
                $content = [regex]::Replace($content, 'plugin-name', $PLUGIN_NAME_HYPHEN)
                $content = [regex]::Replace($content, 'Plugin_Name', $PLUGIN_NAME_CLASSCASE)

                # Write the modified content back to the file
                $content | Set-Content $filePath -Encoding UTF8
            }
        } catch {
            Write-Host "Error: $_"
        }
    }
}

# Call the functions
Rename-Files -directory $PLUGIN_DIR
Replace-Text -directory $PLUGIN_DIR

# Rename the plugin folder
$NewPluginDir = $PLUGIN_DIR -replace "plugin-name", $PLUGIN_NAME_HYPHEN
Rename-Item -Path $PLUGIN_DIR -NewName $NewPluginDir

# Cheers!
Write-Host "Done. Your new plugin project is all set !" -ForegroundColor Green
