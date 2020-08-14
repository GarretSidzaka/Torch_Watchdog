@echo off
title Torch_Watchdog

:watchdogstart
SETLOCAL ENABLEDELAYEDEXPANSION
echo Killing any torch processes with hung statuses.... >> "C:\autorestart.log"

taskkill /f /fi "imagename eq Torch.Server.exe" /fi "status ne running"

taskkill /f /fi "imagename eq Torch.Server.exe" /fi "windowtitle eq Assertion Failed: Abort=Quit, Retry=Debug, Ignore=Continue"


echo Checking paths for executables >> "C:\autorestart.log"
:: set this to match the path that contains all of your torch folders

set "path=C:\Torches"


For /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)

set "now=%mydate% %time%"


cd %path%


%SystemRoot%\System32\Wbem\wmic process get ExecutablePath > "C:\autorestart.log"


for /f "delims=" %%F in ('dir /B /AD "%path%"') Do (


	set "file=%path%\%%F\Torch.Server.exe"


	if exist "!file!" (

echo Found executable at "!file!" >> "%path%\autorestart.log"
		%SYSTEMROOT%\System32\find /c "!file!" "C:\autorestart.log"

		IF ERRORLEVEL 1 (

echo Restarting !file! >> "%path%\autorestart.log"
			echo %now% !file! >> "C:\autorestart.log"

			start "" "!file!"

		)

	)

)


del "%path%\runningProcesses.txt"
echo Beginning timeout, followed by re-looping
C:\windows\system32\timeout /t 300 /NOBREAK
goto watchdogstart
