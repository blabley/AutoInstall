#Windows 7+ Auto Install file from blabley.org
Invoke-WebRequest -UseBasicParsing "https://github.com/blabley/AutoInstall/archive/master.zip" -OutFile "$env:TEMP\AutoInstall.zip" -PassThru
Expand-Archive -Path "$env:TEMP\AutoInstall.zip" -DestinationPath "$env:TEMP\AutoInstall" -Force
Move-Item -LiteralPath "$env:TEMP\AutoInstall\AutoInstall-master" -Destination "$env:SystemDrive\Install99" -Force
cmd /c "%systemdrive%\Install\AutoInstall.cmd"