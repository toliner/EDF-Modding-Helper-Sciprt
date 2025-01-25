<#
.SYNOPSIS
    This script is useful command wrapper for EDF Modding.

.DESCRIPTION
    USAGE
        make.ps1 <Command>

        Command:
            - help : Show this help
            - compile : Compile weapon json files to sgo files
            - deploy : Copy mod files to EDF6 Mods folder
            - build : Compile and deploy
#>
param(
    [Parameter(Position = 0, Mandatory = $true)]
    [ValidateSet('help', 'compile', 'deploy', 'build')]
    [string]$Command
)

$outFolderPath = Join-Path -Path (Get-Location) -ChildPath "out"
$dotEdfFilePath = Join-Path -Path (Get-Location) -ChildPath ".edf"
$edf6Path = Get-Content -Path $dotEdfFilePath
$modFolderPath = Join-Path -Path $edf6Path -ChildPath "Mods"

function commandHelp { 
    Get-Help $PSCommandPath 
}

function commandCompile { 
    compileWeapon
}

function commandDeploy {
    Get-ChildItem -Path $outFolderPath -Recurse | ForEach-Object {
        $destinationPath = $_.FullName.Replace($outFolderPath, $modFolderPath)
        if ($_.PSIsContainer) {
            if (-not (Test-Path -Path $destinationPath)) {
                New-Item -ItemType Directory -Path $destinationPath -Force
            }
        } else {
            Copy-Item -Path $_.FullName -Destination $destinationPath -Force
        }
    }
}

function commandBuild { 
    compileWeapon 
    commandDeploy
}

function compileWeapon {
    $weaponFolderPath = Join-Path -Path (Get-Location) -ChildPath "WEAPON"
    $jsonFiles = Get-ChildItem -Path $weaponFolderPath -Filter *.json -File
    $outFolderPath = Join-Path -Path $outFolderPath -ChildPath "WEAPON"
    $sgott = Join-Path -Path (Get-Location) -ChildPath "sgott.exe"
    foreach ($jsonFile in $jsonFiles) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $parts = $fileName -split '-'
        $outFileName = $parts[-1]
        $outFilePath = Join-Path -Path $outFolderPath -ChildPath "$outFileName.sgo"
        $outFile = Get-Item -Path $outFilePath -ErrorAction SilentlyContinue
        if ($outFile.LastWriteTime -lt $jsonFile.LastWriteTime) {
            Invoke-Expression "$sgott '$jsonFile' '$outFilePath'"
        }
    }
}

switch ($Command) {
    'help' { commandHelp }
    'compile' { commandCompile }
    'deploy' { commandDeploy }
    'build' { commandBuild }
}
