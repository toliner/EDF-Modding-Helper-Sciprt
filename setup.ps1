<#
.SYNOPSIS
    Setup script for make.ps1

.DESCRIPTION
    USAGE
        setup.ps1
#>

# スクリプト固有のファイル群を生成
$outFolderPath = Join-Path -Path (Get-Location) -ChildPath "out"
$dotEdfFilePath = Join-Path -Path (Get-Location) -ChildPath ".edf"
if (-not (Test-Path -Path $outFolderPath)) {
    New-Item -ItemType Directory -Path $outFolderPath
}
if (-not (Test-Path -Path $dotEdfFilePath)) {
    Write-Host "Please write path of folder that contains 'edf6.exe'."
    Write-Host "Example: C:\Program Files (x86)\Steam\steamapps\common\EARTH DEFENSE FORCE 6"
    $edfFolderPath = Read-Host "EDF Folder Path"
    if (-not (Test-Path -Path (Join-Path -Path $edfFolderPath -ChildPath "EDF6.exe"))) {
        Write-Host "Invalid path or 'edf6.exe' not found in the specified folder."
        exit
    }
    New-Item -ItemType File -Path $dotEdfFilePath -Value $edfFolderPath
}

# EDF6 Mods フォルダを生成
$weaponFolderPath = Join-Path -Path (Get-Location) -ChildPath "WEAPON"
if (-not (Test-Path -Path $weaponFolderPath)) {
    New-Item -ItemType Directory -Path $weaponFolderPath
}
$missionFolderPath = Join-Path -Path (Get-Location) -ChildPath "MISSION"
if (-not (Test-Path -Path $missionFolderPath)) {
    New-Item -ItemType Directory -Path $missionFolderPath
}
$modFolderPath = Join-Path -Path (Get-Content -Path $dotEdfFilePath) -ChildPath "Mods"
if (-not (Test-Path -Path $modFolderPath)) {
    New-Item -ItemType Directory -Path $modFolderPath
}
$weaponOutFolderPath = Join-Path -Path $outFolderPath -ChildPath "WEAPON"
if (-not (Test-Path -Path $weaponOutFolderPath)) {
    New-Item -ItemType Directory -Path $weaponOutFolderPath
}
$missionOutFolderPath = Join-Path -Path $outFolderPath -ChildPath "MISSION"
if (-not (Test-Path -Path $missionOutFolderPath)) {
    New-Item -ItemType Directory -Path $missionOutFolderPath
}
$weaponModFolderPath = Join-Path -Path $modFolderPath -ChildPath "WEAPON"
if (-not (Test-Path -Path $weaponModFolderPath)) {
    New-Item -ItemType Directory -Path $weaponModFolderPath
}
$missionModFolderPath = Join-Path -Path $modFolderPath -ChildPath "MISSION"
if (-not (Test-Path -Path $missionModFolderPath)) {
    New-Item -ItemType Directory -Path $missionModFolderPath
}

# sgott.exe をダウンロード
$url = "https://github.com/zeddidragon/sgott/releases/latest/download/sgott.exe"
$sgottPath = Join-Path -Path (Get-Location) -ChildPath "sgott.exe"
if (-not (Test-Path -Path $sgottPath)) {
    Write-Host "Download sgott.exe"
    try {
        Invoke-WebRequest -Uri $url -OutFile $sgottPath
        Write-Host "File downloaded successfully to $sgottPath"
    } catch {
        Write-Host "Failed to download file: $_"
    }
}
