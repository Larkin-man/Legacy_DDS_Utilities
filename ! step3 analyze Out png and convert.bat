@echo off
chcp 65001 >nul
title Step 3: Analysis and Conversion

if not exist texconv.exe (
    echo ERROR: texconv.exe not found!
    pause
    exit /b
)

if not exist analyze_and_convert.ps1 (
    echo ERROR: analyze_and_convert.ps1 not found!
    pause
    exit /b
)

echo Starting analysis and automatic conversion...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File analyze_and_convert.ps1

echo.
echo Press any key to open the report...
pause >nul

start notepad.exe convert_log.txt