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
$sgott = Join-Path -Path (Get-Location) -ChildPath "sgott.exe"

function commandHelp { 
    Get-Help $PSCommandPath 
}

function commandCompile { 
    compileWeapon
    compileMission
}

function commandDeploy {
    Get-ChildItem -Path $outFolderPath -Recurse | ForEach-Object {
        $destinationPath = $_.FullName.Replace($outFolderPath, $modFolderPath)
        if ($_.PSIsContainer) {
            if (-not (Test-Path -Path $destinationPath)) {
                New-Item -ItemType Directory -Path $destinationPath -Force
            }
        }
        else {
            Copy-Item -Path $_.FullName -Destination $destinationPath -Force
        }
    }
}

function commandBuild { 
    commandCompile
    commandDeploy
}

function compileWeapon {
    $weaponFolderPath = Join-Path -Path (Get-Location) -ChildPath "WEAPON"
    $jsonFiles = Get-ChildItem -Path $weaponFolderPath -Filter *.json -File
    $outFolderPath = Join-Path -Path $outFolderPath -ChildPath "WEAPON"
    
    foreach ($jsonFile in $jsonFiles) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $parts = $fileName -split '-'
        $outFileName = $parts[-1]
        $outFilePath = Join-Path -Path $outFolderPath -ChildPath "$outFileName.sgo"
        $outFile = Get-Item -Path $outFilePath -ErrorAction SilentlyContinue
        if (!$outFile -or ($outFile.LastWriteTime -lt $jsonFile.LastWriteTime)) {
            Invoke-Expression "$sgott '$jsonFile' '$outFilePath'"
        }
    }
}

function compileMission {
    $missionFolderPath = Join-Path -Path (Get-Location) -ChildPath "MISSION"
    $missionSubFolders = Get-ChildItem -Path $missionFolderPath -Directory -Recurse
    $rmpaProcessor = Join-Path -Path (Get-Location) -ChildPath "RMPA-Processor.exe"

    # Compile Mission Script Files
    foreach ($subFolder in $missionSubFolders) {
        $relativeFolderPath = [System.IO.Path]::GetRelativePath((Get-Location), $subFolder.FullName)
        $missionOutFolderPath = Join-Path -Path $outFolderPath -ChildPath $relativeFolderPath
        if (-not (Test-Path -Path $missionOutFolderPath)) {
            New-Item -ItemType Directory -Path $missionOutFolderPath -Force
        }
        $acFile = Get-ChildItem -Path $subFolder.FullName -Filter "MISSION.AC" -File -ErrorAction SilentlyContinue
        $jsonFile = Get-ChildItem -Path $subFolder.FullName -File | Where-Object { $_.Name -match '^MISSION\.json$' }
        $rmpaFile = Get-ChildItem -Path $subFolder.FullName -File | Where-Object { $_.Name -match '^RMPA\.json$' }
            
        if ($acFile) {
            Write-Host "Processing $acFile"
            $destinationPath = Join-Path -Path $missionOutFolderPath -ChildPath "MISSION.AC"
            $outFile = Get-Item -Path $destinationPath -ErrorAction SilentlyContinue
            if (!$outFile -or ($outFile.LastWriteTime -lt $acFile.LastWriteTime)) {
                $destinationDir = [System.IO.Path]::GetDirectoryName($destinationPath)
                if (-not (Test-Path -Path $destinationDir)) {
                    New-Item -ItemType Directory -Path $destinationDir -Force
                }
                Copy-Item -Path $acFile.FullName -Destination $destinationPath -Force
            }
        }

        if ($jsonFile) {
            Write-Host "Processing $jsonFile"
            $destinationPath = Join-Path -Path $missionOutFolderPath -ChildPath "MISSION.json"
            $outFile = Get-Item -Path $destinationPath -ErrorAction SilentlyContinue
            if (!$outFile -or ($outFile.LastWriteTime -lt $jsonFile.LastWriteTime)) {
                Copy-Item -Path $jsonFile.FullName -Destination $destinationPath -Force
            }
        }

        if ($rmpaFile) {
            Write-Host "Processing $rmpaFile"
            $destinationPath = Join-Path -Path $missionOutFolderPath -ChildPath "MISSION.RMPA"
            $outFile = Get-Item -Path $destinationPath -ErrorAction SilentlyContinue
            if (!$outFile -or ($outFile.LastWriteTime -lt $rmpaFile.LastWriteTime)) {
                Invoke-Expression "$rmpaProcessor '$rmpaFile' '$destinationPath'"
            }
        }
    }

    # Compile Mission List & Text Files
    $jsonFiles = Get-ChildItem -Path $missionFolderPath -Filter *.json -File
    $missionOutFolderPath = Join-Path -Path $outFolderPath -ChildPath "MISSION"
    foreach ($jsonFile in $jsonFiles) {
        $fileName = [System.IO.Path]::GetFileNameWithoutExtension($jsonFile.Name)
        $parts = $fileName -split '-'
        $outFileName = $parts[-1]
        $outFilePath = Join-Path -Path $missionOutFolderPath -ChildPath "$outFileName.sgo"
        $outFile = Get-Item -Path $outFilePath -ErrorAction SilentlyContinue
        if (!$outFile -or ($outFile.LastWriteTime -lt $jsonFile.LastWriteTime)) {
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
