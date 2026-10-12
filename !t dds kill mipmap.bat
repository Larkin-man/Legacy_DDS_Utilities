@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

cd /d "%~dp0"
set "CONV_DIR=Out"

if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo =================================================== > "%REPORT%"
echo   ОТЧЕТ ПО УДАЛЕНИЮ МИПМАПОВ ЧЕРЕЗ TEXCONV >> "%REPORT%"
echo =================================================== >> "%REPORT%"

echo Удаление мипмапов через texconv...

for %%F in (*.dds) do (
    set "ATTR=%%~aF"
    if not "!ATTR:~0,1!"=="d" (
        echo [ОБРАБОТКА]: %%~nxF
        rem -m 1 оставляет только первый уровень мипмапов
        texconv.exe -m 1 -y -nologo -o "%CONV_DIR%" "%%F"
    )
)
echo Готово!
pause
