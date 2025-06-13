# New-ShotFolders.ps1
# ----------------------------------------
# Usage: .\New-ShotFolders.ps1 <Number of shots to create>
# This number is zero-based – '1' will create only 'sh000'.
# ----------------------------------------

# 1) Argument validation
if ($args.Count -ne 1) {
    Write-Host "Usage: $($MyInvocation.MyCommand.Name) <Number of shots to create>"
    Write-Host "This number is zero-based e.g. '1' will only create 'sh000'."
    exit 1
}

$shots = $args[0]

if (-not ($shots -match '^[0-9]+$')_ {
    Write-Host "Error: shots must be a non-negative integer"
    exit 1
}

$shots = [int]$shots

# 2) Create the EDIT folder structure
$editDirs = 'Footage','EXPORTS','Resolve','Thumbnail'
foreach ($d in $editDirs) {
    New-Item -Path (Join-Path 'EDIT' $d) -ItemType Directory -Force | Out-Null
}

# 3) Loop and create each shot directory with its subfolders
for ($i = 0; $i -lt $shots; $i++) {
    $shotName = 'sh' + $i.ToString('D3')

    # Blender subfolders
    $blenderSubs = 'Geo','Scenes','Renders','Sims','CameraTracks','Textures'
    foreach ($sub in $blenderSubs) {
        New-Item -Path (Join-Path $shotName "Blender\$sub") -ItemType Directory -Force | Out-Null
    }

    # Nuke subfolders
    $nukeSubs = 'Live_Action','Comps','Scripts','Precomps'
    foreach ($sub in $nukeSubs) {
        New-Item -Path (Join-Path $shotName "Nuke\$sub") -ItemType Directory -Force | Out-Null
    }
}

Write-Host "Created $shots shot folder(s) successfully."
exit 0
