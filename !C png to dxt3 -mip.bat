@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

rem Принудительный переход в папку, где лежит сам батник и ваши PNG файлы
cd /d "%~dp0"

set "CRUNCH_PATH=C:\INSTALL\crunch-master\bin\crunch.exe"
set "CONV_DIR=Out"

rem Создаем папку Out, если её еще нет
if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo ===================================================
echo   КОНВЕРТАЦИЯ PNG -> DXT3 (CRUNCH v1.04U)
echo ===================================================
echo.
echo Начинается поштучная обработка PNG файлов...
echo Режим: Без мипмапов, максимальное качество RDO
echo.

rem Перебираем все .png файлы в текущей папке
for %%F in (*.png) do (
    set "ATTR=%%~aF"
    if not "!ATTR:~0,1!"=="d" (
        
        echo [КОНВЕРТАЦИЯ]: %%~nxF
        
        rem Передаем точный путь и оригинальное имя с новым расширением .dds
        "%CRUNCH_PATH%" -file "%%F" -fileformat dds -dxt3 -mipmode none -imagestats -out "%CONV_DIR%\%%~nF.dds"
        
    )
)

echo.
echo Конвертация успешно завершена! Все файлы в папке "%CONV_DIR%".
echo.
pause