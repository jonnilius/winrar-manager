@echo off
REM ================================================================
REM WinRAR Manager Skript
REM Version: 1.0.1
REM Autor: Jonnilius
REM
REM Dieses Skript verwendet:
REM  • Keygen von "bitcookies"
REM    https://github.com/bitcookies/winrar-keygen
REM ================================================================
chcp 65001 >nul


REM ADMINISTRATOR-RECHTE
mode 60, 17
NET SESSION >nul 2>&1
if not %errorLevel% == 0 ( 
    echo.[7;15H[36m┌───────────────────────────────┐
    echo.[8;15H│  [0mAdministrator-Rechte ...     [36m│
    echo.[9;15H└───────────────────────────────┘[0m
    powershell.exe "start cmd.exe -arg '/c \"%~f0\"' -verb runas" && exit /b 
)


REM WINDOWS
mode 46, 35 
set Version=1.0.1
title WinRAR Manager Skript %Version%

:: Position Infobox
Set InfoBoxY=27
Set InfoBoxX=7
call :infobox

:: Position WinRAR-Logo
Set LogoX=7
Set LogoY=3
call :logo

:: Cursor ausblenden
Set CursorInvisible=echo.[?25l
Set CursorVisible=echo.[?25h
%CursorInvisible%

:: Textformatierung
Set Red_=[31m
Set Green_=[32m
Set Yellow_=[33m
Set Gray_=[38;5;8m
Set Underline=[4m

Set /A LogoBottom=%LogoY%+14
Set Clear=echo.[%LogoBottom%;0H [0J
Set RESET=[0m


:: ==============================================================================
:MainMenu
Set MenuY=18
Set MenuX=10
%Clear%
call :infobox
call :menu "" "%OptionOne%" "%OptionTwo%"
choice /C:12q /N /M "" >nul
if %errorLevel%==1 (
    if %Installed%==yes goto :Delete
    if %Installed%==no goto :Install
)
if %errorLevel%==2 call :License
if %errorlevel%==3 exit
goto :MainMenu


:: ==============================================================================
:Install
%Clear%
for /L %%a in (0,1,8) do ( Set /A Y%%a=%MenuY%+%%a )
for /L %%a in (0,1,8) do ( Set /A X%%a=%MenuX%+%%a )
setlocal enabledelayedexpansion
echo.[%Y0%;%X0%H %Underline%WinRAR installieren%RESET%

if %License%==no (
    cd "%ProgramFiles%"
    echo.[%Y2%;%X1%H %Red_%Name:%RESET%
    %CursorVisible%
    set /p name="[%Y2%;%X8%H"
    %CursorInvisible%
    if not exist "WinRAR" mkdir WinRAR
)
%Clear%
echo.[%Y0%;%X0%H %Underline%WinRAR installieren%RESET%
echo.[%Y2%;%X1%H Sprache: Deutsch
echo.[%Y4%;%X1%H Version: 7.01
echo.[%Y6%;%X0%H %Yellow_%Herunterladen...
cd %temp%
if %License%==no (
    powershell "Invoke-WebRequest -o winrar-keygen.exe https://github.com/bitcookies/winrar-keygen/releases/download/v3.0.0/winrar-keygen-x64.exe"
    winrar-keygen.exe "!name!" "Single PC usage license" > rarreg.key
    move rarreg.key "%ProgramFiles%\WinRAR\rarreg.key" >NUL
    del winrar-keygen.exe
)
powershell "Invoke-WebRequest -o winrar7.01-x64-de.exe https://www.rarlab.com/rar/winrar-x64-701d.exe"
echo.[%Y8%;%X0%H %Yellow_%Installation starten...%RESET%
timeout 2 >NUL
start winrar7.01-x64-de.exe /Wait
::start "" "%~dpnx0" && exit
exit
goto :eof

:: ==============================================================================
:Delete
%Clear%
for /L %%a in (0,1,8) do ( Set /A Y%%a=%MenuY%+%%a )
echo.[%Y0%;%MenuX%H %Underline%WinRAR deinstallieren%RESET%
pushd "%ProgramFiles%\WinRAR"
echo.[%Y3%;%MenuX%H %Yellow_%Uninstaller starten...%RESET%
timeout 2 >NUL
start /wait uninstall.exe
popd
timeout 5>NUL
goto :MainMenu


:: ==============================================================================
:License
setlocal enabledelayedexpansion
echo.%clear%
call :infobox
if %License%==yes (
    echo.[17;7H %Underline%Lizenz löschen%RESET%
    echo.[24;7H %Yellow_%Lizenz wird gelöscht...
    del "%ProgramFiles%\WinRAR\rarreg.key" && echo.[24;7H %Green_%Lizenz gelöscht%RESET%            
) else (
    echo.[17;7H %Underline%Lizenz erstellen%RESET%
    echo.[19;7H %Yellow_%Name:%RESET%
    set /p name="[19;14H"
    cd "%ProgramFiles%\WinRAR"
    powershell "curl -o winrar-keygen.exe https://github.com/bitcookies/winrar-keygen/releases/download/v3.0.0/winrar-keygen-x64.exe"
    winrar-keygen.exe "!name!" "Single PC usage license" > rarreg.key
    echo.[24;7H %Green_%Lizenz erstellt%RESET%
    del winrar-keygen.exe
    timeout 3 >nul
    start "" "%~dpnx0" && exit
)
timeout 3 >nul
goto :MainMenu

:: ==============================================================================
:menu
for /L %%a in (0,1,8) do ( Set /A Y%%a=%MenuY%+%%a )
if not "%~2"=="" (
    echo.[%Y0%;%MenuX%H┌─┐
    echo.[%Y1%;%MenuX%H│1│ %~2
    echo.[%Y2%;%MenuX%H└─┘
)
if not "%~3"=="" (
    echo.[%Y3%;%MenuX%H┌─┐
    echo.[%Y4%;%MenuX%H│2│ %~3
    echo.[%Y5%;%MenuX%H└─┘
)
if not "%~4"=="" (
    echo.[%Y6%;%MenuX%H┌─┐
    echo.[%Y7%;%MenuX%H│3│ %~4
    echo.[%Y8%;%MenuX%H└─┘
)
goto :eof



:: ==============================================================================
:logo
for /L %%a in (0,1,12) do ( Set /A Y%%a=%LogoY%+%%a )
echo.[%Y0%;%LogoX%H [48;2;189;16;46m[38;2;206;157;58m   ▄▄         ███████           [0m
echo.[%Y1%;%LogoX%H [48;2;189;16;46m[38;2;206;157;58m   ██         ███████           [0m  
echo.[%Y2%;%LogoX%H [48;2;162;14;36m[38;2;206;157;58m   ██         ███████           [0m  
echo.[%Y3%;%LogoX%H [48;2;162;14;36m[38;2;206;157;58m   ▀▀         ███████           [0m  
echo.[%Y4%;%LogoX%H [48;2;58;61;162m[38;2;206;157;58m   ▄▄         ███████           [0m  
echo.[%Y5%;%LogoX%H [48;2;58;61;162m[38;2;206;157;58m   ██       [38;2;130;133;138m██[38;2;206;157;58m███████[38;2;130;133;138m██[38;2;206;157;58m         [0m   
echo.[%Y6%;%LogoX%H [48;2;50;49;125m[38;2;206;157;58m   ██       [38;2;196;206;208m██[38;2;206;157;58m███████[38;2;196;206;208m██[38;2;206;157;58m         [0m   
echo.[%Y7%;%LogoX%H [48;2;50;49;125m[38;2;206;157;58m   ▀▀       [38;2;196;206;208m██[38;2;206;157;58m███[38;2;196;206;208m█[38;2;206;157;58m███[38;2;196;206;208m██[38;2;206;157;58m         [0m   
echo.[%Y8%;%LogoX%H [48;2;30;146;59m[38;2;206;157;58m   ▄▄       [38;2;196;206;208m███████████[38;2;206;157;58m         [0m   
echo.[%Y9%;%LogoX%H [48;2;30;146;59m[38;2;206;157;58m   ██         ███████           [0m   
echo.[%Y10%;%LogoX%H [48;2;22;116;44m[38;2;206;157;58m   ██         ███████           [0m   
echo.[%Y11%;%LogoX%H [48;2;22;116;44m[38;2;206;157;58m   ▀▀         ███████           [0m    
goto :eof



:: ==============================================================================
:infobox 
for /L %%a in (0,1,10) do ( Set /A Y%%a=%InfoBoxY%+%%a )
for /L %%a in (0,1,40) do ( Set /A X%%a=%InfoBoxX%+%%a )

REM Installation
if exist "%ProgramFiles%\WinRAR\WinRAR.exe" (
    set Installed=yes
    set InstallDisplay=%Green_%Ja%RESET%
    set OptionOne=WinRAR deinstallieren
) else (
    set Installed=no
    set InstallDisplay=%Red_%Nein%RESET%
    set OptionOne=WinRAR installieren
)
echo.[%Y2%;%X2%H WinRAR installiert: %InstallDisplay%

REM Lizenz
if exist "%ProgramFiles%\WinRAR\rarreg.key" (
    Set License=yes
    Set LicenseDisplay=%Green_%vorhanden%RESET%
    Set OptionTwo=Lizenz entfernen
) else (
    Set License=no
    Set LicenseDisplay=-%RESET%
    if %Installed%==yes (
        Set OptionTwo=Lizenz hinzufügen
    )
)
echo.[%Y4%;%X2%H Lizenz: %LicenseDisplay%

REM RAHMEN
echo.[%Y0%;%X0%H╭───────────────────────────────╮
for /L %%a in (%Y1%,1,%Y5%) do ( echo.[%%a;%X0%H│[%%a;%X32%H│ )
echo.[%Y6%;%X0%H╰───────────────────────────────╯
goto :eof

