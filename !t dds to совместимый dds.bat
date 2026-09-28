@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

title Morrowind DDS Fix - Convert to DXT5

if not exist texconv.exe (
    echo ERROR: texconv.exe not found!
    pause
    exit /b
)

if not exist texdiag.exe (
    echo ERROR: texdiag.exe not found!
    pause
    exit /b
)

if not exist Morrowind_Compatible mkdir Morrowind_Compatible

echo ============================================================
echo  Morrowind DDS Fix
echo  Converting incompatible formats to DXT5 (BC3_UNORM)
echo ============================================================
echo.
echo  Supported by Morrowind: DXT1 (BC1), DXT3 (BC2), DXT5 (BC3)
echo  Will be converted to DXT5: BC4, BC5, BC6, BC7, uncompressed, etc.
echo.

set "converted=0"
set "skipped=0"
set "errors=0"

for %%f in (*.dds) do (
    echo Checking: %%f
    
    REM Get only the format line (using /C: for exact substring match)
    set "format_line="
    for /f "tokens=*" %%a in ('texdiag.exe info "%%f" 2^>^&1 ^| findstr /I /C:"format ="') do (
        set "format_line=%%a"
    )
    
    if not defined format_line (
        echo   [ERROR] Could not read format
        set /a errors+=1
    ) else (
        echo   Found: !format_line!
        
        REM Check if format is already compatible (BC1, BC2, BC3)
        set "is_compatible=0"
        echo !format_line! | findstr /I /C:"BC1" >nul
        if !errorlevel! equ 0 set "is_compatible=1"
        
        echo !format_line! | findstr /I /C:"BC2" >nul
        if !errorlevel! equ 0 set "is_compatible=1"
        
        echo !format_line! | findstr /I /C:"BC3" >nul
        if !errorlevel! equ 0 set "is_compatible=1"
        
        if !is_compatible! equ 1 (
            echo   [SKIP] Already compatible with Morrowind
            set /a skipped+=1
        ) else (
            echo   [CONVERT] Incompatible format - converting to DXT5...
            
            REM Convert to DXT5 with DX9 headers for Morrowind compatibility
            texconv.exe -nologo -f BC3_UNORM -dx9 -y -o Morrowind_Compatible "%%f" >nul 2>&1
            
            if exist "Morrowind_Compatible\%%~nxf" (
                echo   [OK] Saved to Morrowind_Compatible\%%~nxf
                set /a converted+=1
            ) else (
                echo   [ERROR] Conversion failed
                set /a errors+=1
            )
        )
    )
    echo.
)

echo ============================================================
echo  Done!
echo  Converted to DXT5: !converted!
echo  Skipped (already compatible): !skipped!
echo  Errors: !errors!
echo  Output folder: Morrowind_Compatible
echo ============================================================
pause