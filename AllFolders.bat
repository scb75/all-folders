@echo off
setlocal EnableDelayedExpansion

REM -------------------------------------------------------------------
REM Usage check: require exactly one argument
REM -------------------------------------------------------------------
if "%~1"=="" goto :usage
if NOT "%~2"=="" goto :usage

set "shots=%~1"

REM -------------------------------------------------------------------
REM Validate numeric (non‐negative integer)
REM -------------------------------------------------------------------
echo %shots%| findstr /R "[^0-9]" >nul
if %errorlevel% equ 0 (
    echo Error: shots must be a non-negative integer
    exit /B 1
)

set /A last=shots - 1

REM -------------------------------------------------------------------
REM Create the EDIT folder tree
REM -------------------------------------------------------------------
for %%D in (Footage EXPORTS Resolve Thumbnail) do (
    md "EDIT\%%D" 2>nul
)

REM -------------------------------------------------------------------
REM Loop from 0 to shots-1, zero-pad index to 3 digits, and create subfolders
REM -------------------------------------------------------------------
for /L %%i in (0,1,%last%) do (
    REM zero-pad (e.g. 0 → 000, 12 → 012)
    set "num=00%%i"
    set "num=!num:~-3!"
    set "shot=sh!num!"

    REM Blender subfolders
    for %%B in (Geo Scenes Renders Sims CameraTracks Textures) do (
        md "!shot!\Blender\%%B" 2>nul
    )

    REM Nuke subfolders
    for %%N in (Live_Action Comps Scripts Precomps) do (
        md "!shot!\Nuke\%%N" 2>nul
    )
)

echo Created %shots% shot folder(s) successfully.
exit /B 0

:usage
echo Usage: %~nx0 ^<Number of shots to create^>
echo This number is zero-based e.g. “1” only will create “sh000”.
exit /B 1
