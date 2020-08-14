@echo off
title Torch_Watchdog

:watchdogstart

echo Killing any torch processes with hung statuses....
echo Killing any torch processes with hung statuses.... >> "C:\autorestart.log"

%SystemRoot%\system32\taskkill /f /fi "imagename eq Torch.Server.exe" /fi "status ne running"
%SystemRoot%\system32\taskkill /f /fi "imagename eq Torch.Server.exe" /fi "windowtitle eq Assertion Failed: Abort=Quit, Retry=Debug, Ignore=Continue"

SETLOCAL ENABLEDELAYEDEXPANSION

echo Checking paths for executables
echo Checking paths for executables >> "C:\autorestart.log"

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
echo Found executable at "!file!" >> "C:\autorestart.log"
        %SYSTEMROOT%\System32\find /c "!file!" "C:\autorestart.log"

        IF ERRORLEVEL 1 (

echo Restarting !file!
echo Restarting !file! >> "C:\autorestart.log"
            echo %now% !file!
            echo %now% !file! >> "C:\autorestart.log"

            start "" "!file!"

        )

    )

)


echo Beginning timeout, followed by restarting script
echo Beginning timeout, followed by restarting script >> "C:\autorestart.log"
%SystemRoot%\system32\timeout /t 300 /NOBREAK
goto watchdogstart
