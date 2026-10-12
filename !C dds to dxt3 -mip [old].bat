@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

rem Принудительный переход в папку, где лежит сам батник и ваши текстуры
cd /d "%~dp0"

set "CRUNCH_PATH=C:\INSTALL\crunch-master\bin\crunch_x64.exe"
set "CONV_DIR=Out"

rem Создаем папку Out, если её еще нет
if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo Начинается сжатие текстур через Crunch компрессор...
echo Режим: Superintelligent Максимальное качество (БЕЗ МИПМАПОВ)
echo.

rem Запуск crunch с исправленными параметрами
rem -dxt3            : формат сжатия DXT3
rem -mipmode None    : полностью отключает генерацию мипмапов
rem -dxt_quality superintelligent : включает максимальный математический перебор для DXT
rem -out             : указывает целевую папку
for %%F in (*.dds) do (
"%CRUNCH_PATH%" -file %%F -dxt3 -quality 255 -mipmode None -out "Out/%%F"
)

echo.
echo Процесс завершен! Проверьте папку "%CONV_DIR%".
pause
