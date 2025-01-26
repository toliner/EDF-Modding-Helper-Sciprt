# EDF Modding Helper Script
[Japanese version here](README.md)

## Overview
This is a helper script for modding EDF 6.
It mainly uses tools like sgott to convert JSON to SGO and transfer mod files.

## Usage
1. Place `setup.ps1` and `make.ps1` in the working folder of your mod.
2. Run `setup.ps1`. This will create the necessary folders and download sgott.
3. Create JSON files for your mod.
4. Run `.\make.ps1 build`.

## Features
The currently implemented features are as follows:

### compile
#### Weapon
Compiles JSON files in the WEAPON folder into SGO files. The compiled SGO files are stored in the out folder.
With the differential compilation feature, only updated files are compiled, reducing compilation time for large mod projects.
Additionally, if the file name is separated by `-`, only the last part is used as the name of the SGO file.
This allows for both easy-to-understand naming and vanilla file replacement.
Example:
- `MPACK_A_WEAPON010.json` -> `MPACK_A_WEAPON010.sgo`
- `Flame-Geyser-F-MPACK_A_WEAPON010` -> `MPACK_A_WEAPON010.sgo`

#### Mission
Compiles JSON files for RMPA in MISSION folder into RMPA files.  
JSON files for RMPA should be named "RMPA.json". It isn't case-sensitive  

### deploy
Copies files from the out folder to the mod folder.

### build
Executes both compile and deploy.

## .gitignore
The .gitignore file in this repository can also be used as a gitignore file for modding projects.
