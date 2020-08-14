@echo off
title Torch_Watchdog
::Torch Watchdog
::Thanks to N1RAN, Jimmacle, and Rexxar for the code and support and great api.
::Instructions:  change the path below to match where you nest *all* of your torch folders, if you have more than one.
::Do not keep any other folders that don't contain torch in there
::


:watchdogstart
SETLOCAL ENABLEDELAYEDEXPANSION
echo Killing any torch processes with hung statuses.... >> "%path%\autorestart.log"

taskkill /f /fi "imagename eq Torch.Server.exe" /fi "status ne running"

taskkill /f /fi "imagename eq Torch.Server.exe" /fi "windowtitle eq Assertion Failed: Abort=Quit, Retry=Debug, Ignore=Continue"


echo Checking paths for executables >> "%path%\autorestart.log"
:: set this to match the path that contains all of your torch folders

set "path=C:\Torches"


For /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)

set "now=%mydate% %time%"


cd %path%


%SystemRoot%\System32\Wbem\wmic process get ExecutablePath > "%path%\runningProcesses.txt"


for /f "delims=" %%F in ('dir /B /AD "%path%"') Do (


	set "file=%path%\%%F\Torch.Server.exe"


	if exist "!file!" (

echo Found executable at "!file!" >> "%path%\autorestart.log"
		%SYSTEMROOT%\System32\find /c "!file!" "%path%\runningProcesses.txt"

		IF ERRORLEVEL 1 (

echo Restarting !file! >> "%path%\autorestart.log"
			echo %now% !file! >> "%path%\autorestart.log"

			start "" "!file!"

		)

	)

)


del "%path%\runningProcesses.txt"
echo Waiting for 5 minutes.... Use control-C to quit.  >> "%path%\autorestart.log"
C:\windows\system32\timeout /t 300 /NOBREAK
goto watchdogstart
