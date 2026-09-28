@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

title PNG to DXT3 (strict black = transparent)

if not exist texconv.exe (
    echo ERROR: texconv.exe not found!
    pause
    exit /b
)

if not exist make_alpha.ps1 (
    echo ERROR: make_alpha.ps1 not found!
    pause
    exit /b
)

if not exist Out mkdir Out
if not exist TempAlpha mkdir TempAlpha

echo ============================================================
echo  PNG to DXT3 (strict black = transparent)
echo  Only pure black pixels (R=0,G=0,B=0) become transparent
echo ============================================================
echo.

set "count=0"
set "errors=0"

for %%f in (*.png) do (
    echo Processing: %%f
    
    REM Step 1: Create PNG with strict alpha
    powershell -NoProfile -ExecutionPolicy Bypass -File make_alpha.ps1 "%%f" "TempAlpha\%%~nf.png" > temp_result.txt 2>&1
    
    if exist "TempAlpha\%%~nf.png" (
        REM Step 2: Convert to DXT3
        texconv.exe -nologo -f BC2_UNORM -m 1 -y -o Out "TempAlpha\%%~nf.png" >nul 2>&1
        
        if exist "Out\%%~nf.dds" (
            set /p result=<temp_result.txt
            echo   [OK] Out\%%~nf.dds  (!result!)
            set /a count+=1
        ) else (
            echo   [ERROR] DDS conversion failed
            set /a errors+=1
        )
    ) else (
        echo   [ERROR] Alpha creation failed
        set /a errors+=1
    )
)

REM Cleanup temp folder
if exist TempAlpha rd /s /q TempAlpha >nul
if exist temp_result.txt del temp_result.txt >nul

echo.
echo ============================================================
echo  Done!
echo  Converted: !count!
echo  Errors: !errors!
echo  Output folder: Out
echo ============================================================
pause