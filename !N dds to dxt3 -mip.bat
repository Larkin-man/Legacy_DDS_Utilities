@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

set "NVTT_PATH=C:\INSTALL\NVIDIA Texture Tools"
set "CONV_DIR=Out"

if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo Начинается сжатие текстур через NVIDIA компрессор...
echo Режим: Production Максимальное качество (БЕЗ МИПМАПОВ)
echo.

rem Перебираем все .dds файлы в текущей папке
for %%F in (*.dds) do (
    set "ATTR=%%~aF"
    if not "!ATTR:~0,1!"=="d" (
        
        echo [СЖАТИЕ NVTT]: %%~nxF
        
        pushd "%NVTT_PATH%"
        rem СТРОГИЙ СИНТАКСИС NVTT: Сначала входной файл, затем все флаги. 
        rem Для отключения мипмапов используется --no-mips.
        nvtt_export.exe "%~dp0%%F" --format bc2 --quality production --no-mips --output "%~dp0%CONV_DIR%\%%~nxF"
        popd
        
    )
)

echo.
echo Процесс завершен. Проверьте папку "%CONV_DIR%".
pause