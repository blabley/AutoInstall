#
#  _     _       _     _                             
# | |   | |     | |   | |                            
# | |__ | | __ _| |__ | | ___ _   _   ___  _ __ __ _ 
# | '_ \| |/ _` | '_ \| |/ _ \ | | | / _ \| '__/ _` |
# | |_) | | (_| | |_) | |  __/ |_| || (_) | | | (_| |
# |_.__/|_|\__,_|_.__/|_|\___|\__, (_)___/|_|  \__, |
#                              __/ |            __/ |
#                             |___/            |___/ 
# Version 0.1 - see blabley.org / https://github.com/blabley for more info
# Windows 7+ Auto Install file from blabley.org

Invoke-WebRequest -UseBasicParsing "https://github.com/blabley/AutoInstall/archive/master.zip" -OutFile "$env:TEMP\AutoInstall.zip" -PassThru
Expand-Archive -Path "$env:TEMP\AutoInstall.zip" -DestinationPath "$env:TEMP\AutoInstall" -Force
Move-Item -LiteralPath "$env:TEMP\AutoInstall\AutoInstall-master" -Destination "$env:SystemDrive\Install" -Force
cmd /c "%systemdrive%\Install\AutoInstall.cmd"