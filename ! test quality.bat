@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"

if not exist TestQuality mkdir TestQuality

echo ============================================================
echo  Testing different quality settings
echo ============================================================
echo.

REM Берем первый DDS файл для теста
set "test_dds="
for %%f in (*.dds) do (
    if not defined test_dds set "test_dds=%%f"
)

if not defined test_dds (
    echo No DDS files found!
    pause
    exit /b
)

set "base_name=!test_dds:~0,-4!"

echo Testing with: !test_dds!
echo Base name: !base_name!
echo.

echo [1/4] Default settings...
texconv.exe -nologo -ft tga -y -o TestQuality "!test_dds!" >nul 2>&1
if exist "TestQuality\!base_name!.png" (
    move "TestQuality\!base_name!.png" "TestQuality\1_default.png" >nul
    echo   [OK] 1_default.png
) else (
    echo   [FAILED]
)

echo [2/4] With sRGB color space...
texconv.exe -nologo -ft tga -srgb -y -o TestQuality "!test_dds!" >nul 2>&1
if exist "TestQuality\!base_name!.png" (
    move "TestQuality\!base_name!.png" "TestQuality\2_srgb.png" >nul
    echo   [OK] 2_srgb.png
) else (
    echo   [FAILED]
)

echo [3/4] With alpha preservation...
texconv.exe -nologo -ft tga -alpha -y -o TestQuality "!test_dds!" >nul 2>&1
if exist "TestQuality\!base_name!.png" (
    move "TestQuality\!base_name!.png" "TestQuality\3_alpha.png" >nul
    echo   [OK] 3_alpha.png
) else (
    echo   [FAILED]
)

echo [4/4] With sRGB + alpha + singlemip...
texconv.exe -nologo -ft tga -srgb -alpha -singlemip -y -o TestQuality "!test_dds!" >nul 2>&1
if exist "TestQuality\!base_name!.png" (
    move "TestQuality\!base_name!.png" "TestQuality\4_best.png" >nul
    echo   [OK] 4_best.png
) else (
    echo   [FAILED]
)

echo.
echo ============================================================
echo  Done! Compare files in TestQuality folder:
echo  1_default.png  - as is
echo  2_srgb.png     - with sRGB correction
echo  3_alpha.png    - with alpha preservation
echo  4_best.png     - combined settings
echo ============================================================
pause