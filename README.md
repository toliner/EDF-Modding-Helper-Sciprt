# EDF Modding Helper Script
[English version is here](README-EN.md)

## 概要
EDF 6のModdingのヘルパースクリプトです。
主にsgott等のツールを利用したjson => sgo変換や、Modファイルの転送などを行います。

## 使い方
1. `setup.ps1`と`make.ps1`をModの作業用フォルダーに置きます
2. `setup.ps1`を実行します。これにより必要なフォルダが作成され、sgottがダウンロードされます。
3. Mod用のjsonファイルを作成します。
4. `.\make.ps1 build` を実行します。

## 機能
現在実装されている機能は以下の通りです

### compile 
#### WEAPON
WEAPONフォルダーのjsonファイルをsgoにコンパイルします。コンパイルされたsgoファイルはoutフォルダに格納されます。  
差分コンパイル機能により、更新されたファイルのみをコンパイルします。大規模なModプロジェクトでのコンパイル時間を短縮します。  
また、ファイル名が`-`で区切られている場合、最後の部分のみをsgoファイルの名前に使用します。
これにより、バニラのファイル書き換えと分かりやすい命名を両立できます。  
例:  
- `MPACK_A_WEAPON010.json` -> `MPACK_A_WEAPON010.sgo`  
- `フレイム・ガイザーF-MPACK_A_WEAPON010` -> `MPACK_A_WEAPON010.sgo`

#### MISSION
MISSIONフォルダーのRMPA用jsonファイルをRMPAにコンパイルします。  
RMPA用jsonファイルは `RMPA.json` という名前である必要があります。拡張子の大文字・小文字は問いません。

### deploy
outフォルダーのファイルをModフォルダーにコピーします。

### build
compileとdeployを両方実行します。  

## .gitignore
このリポジトリの.gitignoreファイルはModdingプロジェクトのgitignoreファイルとしても利用可能です。
