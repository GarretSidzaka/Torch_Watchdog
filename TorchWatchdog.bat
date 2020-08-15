@echo on
title Torch_Watchdog

:watchdogstart

echo Killing any torch processes with hung statuses....


%SystemRoot%\system32\taskkill /f /fi "imagename eq Torch.Server.exe" /fi "status ne running"
%SystemRoot%\system32\taskkill /f /fi "imagename eq Torch.Server.exe" /fi "windowtitle eq Assertion Failed: Abort=Quit, Retry=Debug, Ignore=Continue"

SETLOCAL ENABLEDELAYEDEXPANSION

echo Checking paths for executables


:: set this to match the path that contains all of your torch folders

set "mypath=C:\Torches"


For /f "tokens=1-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)

set "now=%mydate% %time%"


cd %mypath%


%SystemRoot%\System32\Wbem\wmic process get ExecutablePath > "C:\autorestart.log"


for /f "delims=" %%F in ('dir /B /AD "%mypath%"') Do (


    set "file=%mypath%\%%F\Torch.Server.exe"


    if exist "!file!" (

echo Found executable at "!file!"
        %SYSTEMROOT%\System32\find /c "!file!" "C:\autorestart.log"

        IF ERRORLEVEL 1 (

echo Restarting !file!

            echo %now% !file!


            start "" "!file!"

        )

    )

)


echo Beginning timeout, followed by restarting script

%SystemRoot%\system32\timeout /t 300 /NOBREAK
goto watchdogstart
