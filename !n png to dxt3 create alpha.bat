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

if not exist Out mkdir Out
if not exist TempAlpha mkdir TempAlpha

echo ============================================================
echo  PNG to DXT3 via NVIDIA compressor
echo  Step 1: PowerShell creates PNG with alpha (black = transparent)
echo  Step 2: nvdxt.exe converts to DXT3 with highest quality
echo ============================================================
echo.

set "count=0"
set "errors=0"

for %%f in (*.png) do (
    echo Processing: %%f
    
    REM Step 1: Create PNG with strict alpha using PowerShell
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Add-Type -AssemblyName System.Drawing; ^
         $img = [System.Drawing.Image]::FromFile('%%f'); ^
         $bmp = New-Object System.Drawing.Bitmap($img.Width, $img.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb); ^
         $g = [System.Drawing.Graphics]::FromImage($bmp); ^
         $g.DrawImage($img, 0, 0, $img.Width, $img.Height); ^
         $count = 0; ^
         for ($y = 0; $y -lt $bmp.Height; $y++) { ^
             for ($x = 0; $x -lt $bmp.Width; $x++) { ^
                 $p = $bmp.GetPixel($x, $y); ^
                 if ($p.R -eq 0 -and $p.G -eq 0 -and $p.B -eq 0) { ^
                     $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 255, 255, 255)); ^
                     $count++ ^
                 } else { ^
                     $bmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $p.R, $p.G, $p.B)) ^
                 } ^
             } ^
         }; ^
         $bmp.Save('TempAlpha\%%~nf.png', [System.Drawing.Imaging.ImageFormat]::Png); ^
         $bmp.Dispose(); $img.Dispose(); $g.Dispose(); ^
         Write-Host \"  Alpha: $count transparent pixels\""
    
    if exist "TempAlpha\%%~nf.png" (
        REM Step 2: Convert to DXT3 via NVIDIA compressor
        nvdxt.exe -file "TempAlpha\%%~nf.png" -output "Out\%%~nf.dds" -dxt3 -nomipmap -quality_highest >nul 2>&1
        
        if exist "Out\%%~nf.dds" (
            echo   [OK] Out\%%~nf.dds
            set /a count+=1
        ) else (
            echo   [ERROR] nvdxt failed - trying alternative command...
            
            REM Try alternative syntax
            nvdxt.exe -file "TempAlpha\%%~nf.png" -dxt3 -nomipmap > "Out\%%~nf.dds" 2>&1
            
            if exist "Out\%%~nf.dds" (
                echo   [OK] Out\%%~nf.dds (alternative syntax)
                set /a count+=1
            ) else (
                echo   [ERROR] nvdxt failed completely
                set /a errors+=1
            )
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