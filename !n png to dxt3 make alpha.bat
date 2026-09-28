@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

title PNG to DXT3 (NVIDIA compressor)

if not exist nvdxt.exe (
    echo ERROR: nvdxt.exe not found!
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
echo  PNG to DXT3 via NVIDIA compressor
echo ============================================================
echo.

set "count=0"
set "errors=0"

for %%f in (*.png) do (
    echo Processing: %%f
    
    REM Step 1: Create PNG with alpha via PowerShell script
    powershell -NoProfile -ExecutionPolicy Bypass -File make_alpha.ps1 "%%f" "TempAlpha\%%~nf.png"
    
    if exist "TempAlpha\%%~nf.png" (
        REM Step 2: Convert to DXT3 via NVIDIA
        nvdxt.exe -file "TempAlpha\%%~nf.png" -output "Out\%%~nf.dds" -dxt3 -nomipmap -quality_highest >nul 2>&1
        
        if exist "Out\%%~nf.dds" (
            echo   [OK] Out\%%~nf.dds
            set /a count+=1
        ) else (
            echo   [ERROR] nvdxt conversion failed
            set /a errors+=1
        )
    ) else (
        echo   [ERROR] Alpha creation failed
        set /a errors+=1
    )
)

echo.
echo ============================================================
echo  Done!
echo  Converted: !count!
echo  Errors: !errors!
echo  Output folder: Out
echo  TempAlpha folder KEPT for inspection
echo ============================================================
pause