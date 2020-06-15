:: Version 3.0
::
@echo off
COLOR 0A
TITLE Automatic installation started %Time%
::  OS Version
IF "%PROCESSOR_ARCHITECTURE%"=="x86" (set bit=x86) else (set bit=x64)

:: Copying
xcopy /Y /E /C /I %SYSTEMDRIVE%\Install\%bit% %windir%

:: The basics
nircmd.exe mutesysvolume 1
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

:: User config
net accounts /MAXPWAGE:UNLIMITED
net user Administrator /active:yes
net user Administrator 5MX24WJx6KUC
net user Administrator /fullname:"LocalAdmin - %DATE%"
wmic useraccount where name='Administrator' rename LocalAdmin
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v DefaultUserName /t REG_SZ /d %Username%
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v DefaultPassword /t REG_SZ
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v AltDefaultUserName /t REG_SZ /d %Username%
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /f /v AutoAdminLogon /t REG_SZ /d 1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /v Administrator /t REG_DWORD /d 0
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /v LocalAdmin /t REG_DWORD /d 0

:: Remove Windows 10 Ads
REM Turn off Game Bar Tips
REG ADD "HKCU\Software\Microsoft\GameBar" /f /v ShowStartupPanel /t REG_DWORD /d 0
REG ADD "HKU\.DEFAULT\Software\Microsoft\GameBar" /f /v ShowStartupPanel /t REG_DWORD /d 0
REM Turn off "Get tips, tricks and suggestions as you use Windows"
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v SoftLandingEnabled /t REG_DWORD /d 0
REG ADD "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v SoftLandingEnabled /t REG_DWORD /d 0
REM Turn off Start Menu suggestions
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0
REG ADD "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /f /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0
REM Turn off File Explorer ads
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowSyncProviderNotifications /t REG_DWORD /d 0
REG ADD "HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /f /v ShowSyncProviderNotifications /t REG_DWORD /d 0

::  Change computer name
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
WMIC computersystem where caption="%COMPUTERNAME%" rename "PC-%RANDOM%%SEC%"

::  Change computer description
for /f "tokens=2 delims==" %%f in ('wmic COMPUTERSYSTEM get Manufacturer /value ^| find "="') do set "manu=%%f"
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters /v srvcomment /t reg_sz /d "%manu% - %date%, %time:~0,5%" /f

::  Enable components to cleanup
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Active Setup Temp Folders" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\BranchCache" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Downloaded Program Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\GameNewsFiles" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\GameStatisticsFiles" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\GameUpdateFiles" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Memory Dump Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Offline Pages Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Old ChkDsk Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Previous Installations" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Service Pack Cleanup" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Setup Log Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error memory dump files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\System error minidump files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Setup Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Sync Files" /V StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\User file versions" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Defender" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Archive Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting Queue Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Archive Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Error Reporting System Queue Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows ESD installation files" /v StateFlags0100 /d 2 /t REG_DWORD /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Windows Upgrade Log Files" /v StateFlags0100 /d 2 /t REG_DWORD /f
::  Schedule monthly cleanup
schtasks /Create /F /SC MONTHLY /MO first /D MON /rl HIGHEST /TN DiskTidySch /TR "cleanmgr /sagerun:100" /ST 05:00 /SD 01/01/2000

::  Running Windows Post Installer
:ETHCHK
	ECHO      ********************************************************************
	echo                  Checking internet connection, please wait...
	ECHO      ********************************************************************
PING www.blabley.org -4 -n 1 | FIND "TTL=" >NUL
IF NOT ERRORLEVEL 1 GOTO ETHOK
PING www.blabley.org -4 -w 300 | FIND "TTL=" >NUL
IF ERRORLEVEL 1 CLS & (
	ECHO      ********************************************************************
	echo                        ERROR CONNECTING TO INTERNET
	echo.
	echo                       Do you have a valid connection?
	echo                       Press any key to try again...
	ECHO      ********************************************************************
	)
PAUSE >NUL & GOTO ETHCHK
:ETHOK

:: Install all installer package files (.MSI)
FOR %%I IN (%SYSTEMDRIVE%\Install\*.msi) DO start /wait msiexec /i "%%~fI" /passive /norestart /l*V "%%~dpnI.log"

:: Install Chocolatey base and apps
CHOICE /C LBF /T 60 /D B /M "Select [L]ite, [B]asic or [F]ull"
IF errorlevel 1 SET InstallFile=%SYSTEMDRIVE%\Install\choco_lite.txt
IF errorlevel 2 SET InstallFile=%SYSTEMDRIVE%\Install\choco_base.txt
IF errorlevel 3 SET InstallFile=%SYSTEMDRIVE%\Install\choco_full.txt
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
SET /a raHR=(%RANDOM%*4/32768)+10
SET /a raMN=(%RANDOM%*49/32768)+10 
schtasks /create /f /SC weekly /D WED /rl HIGHEST /ru SYSTEM /tn "Update Pre-installed Applications" /tr "choco upgrade all -y" /st %raHR%:%raMN% /sd 01/01/2015
FOR /F %%G IN (%InstallFile%) DO choco install %%G -y
PUSHD %ProgramData%\chocolatey\lib
FOR /R %%C IN (*.exe) DO nircmd shortcut "%%C" "~$folder.programs$\Chocolatey" "%%~nC"
POPD

:: Check for BOINC
IF NOT EXIST "%ProgramFiles%\BOINC\boinccmd.*" GOTO :NoBoinc
:BOINC
START /MIN "BOINC" "%ProgramFiles%\BOINC\boinctray.exe"
START /MIN "BOINC" "%ProgramFiles%\BOINC\boincmgr.exe" /a /s
nircmd win min ititle "BOINC"
CHOICE /C YN /T 30 /D Y >NUL
"%ProgramFiles%\BOINC\boinccmd" --join_acct_mgr http://bam.boincstats.com/ 215223_f76f28e15fc81cf6c0a9ab605d357955 UDZosQ946GBDrp
:NoBoinc

:: Check for Network
ECHO Configure for Work network?
CHOICE /C YN /T 30 /D N
:WorkNet
IF errorlevel 2 goto NotWorkNet
IF errorlevel 1 ECHO Configuring work network...
FOR /F "usebackq delims=\ tokens=8" %%i IN (`reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles"`) DO set x=%%i
REG ADD "HKLM\SOFTWARE\Microsoft\UPnP Device Host\Devices" /F
REG ADD "HKLM\SOFTWARE\Microsoft\UPnP Device Host\Providers" /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\%x%" /V "Category" /t REG_DWORD /D 00000001 /F
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\%x%" /V "CategoryType" /t REG_DWORD /D 00000000 /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\FDResPub" /V "Start" /t REG_DWORD /D 00000002 /F
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\upnphost" /V "Start" /t REG_DWORD /D 00000002 /F
:NotWorkNet
echo Configuring work network...

:: Check for VMware
for /f "tokens=2 eol=, delims==" %%f in ('wmic COMPUTERSYSTEM get Manufacturer /value ^| find "="') do set "myVar=%%f"
IF "%myVar:~0,6%" GEQ "VMware" (GOTO VMware) ELSE (GOTO NoVMware)
:VMware
	Echo VMware found, Shall I install the VMware Tools?
	CHOICE /C YN /T 30 /D Y
	IF errorlevel 2 goto NoVMware
	IF errorlevel 1 ECHO Installing VMware Tools...
		REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V "EnableAutoTray" /t REG_DWORD /D 00000000 /F
		ECHO %DATE% - %TIME% >>%SYSTEMDRIVE%\Install\VMwareInstall.log
		start /wait %SYSTEMDRIVE%\Install\VMwareToolsUpgrader.exe -p "/s /v\"/qr REBOOT=ReallySuppress REBOOTPROMPT=S\""
		7za x %SYSTEMDRIVE%\Install\VDIPro.zip -y -r -o%SYSTEMDRIVE%\Install\VDIPro
			Echo VMware found, Optimize with recommended settings?
			CHOICE /C YN /T 30 /D Y
			IF errorlevel 2 goto NotVMwareRec
			IF errorlevel 1 ECHO Installing VMware Tools...		
			%SYSTEMDRIVE%\Install\VDIPro\VMwareOSOptimizationTool.exe -o recommended -v
			:NotVMwareRec
		FOR %%V IN (%SYSTEMDRIVE%\Install\VDIPro\*.exe) DO nircmd shortcut "%%V" "~$folder.desktop$" "VDI Pro"
		GOTO finalstage
:NoVMware
echo Not Installing VMware Tools...

:finalstage
@powershell -NoProfile -ExecutionPolicy Bypass -File "%SYSTEMDRIVE%\Install\Drivers.ps1"
@powershell -NoProfile -ExecutionPolicy Bypass -File "%SYSTEMDRIVE%\Install\Wallpaper.ps1"


:: Last tidy
DEL /F /Q %APPDATA%\Microsoft\Windows\Recent\*
DEL /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
DEL /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*
DEL /F /Q %TEMP%
DEL /F /Q %TMP%
ATTRIB +S +H +R %SYSTEMDRIVE%\Install
nircmd.exe cdrom open
SETX InstallDrive %SYSTEMDRIVE%\Install
shutdown.exe /r /f /t 30
EXIT