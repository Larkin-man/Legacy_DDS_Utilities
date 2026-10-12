@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
cd /d "%~dp0"

set "CRUNCH_PATH=C:\INSTALL\crunch-master\bin\crunch.exe"
set "CONV_DIR=Out"

if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo Начинается поштучное сжатие DDS текстур через Crunch. -fileformat dds -dxt3 -mipmode none...
echo.

rem Перебираем все .png файлы в текущей папке
for %%i in (*.dds) do (
    set "ATTR=%%~aF"
    if not "!ATTR:~0,1!"=="d" (
        
        echo [СЖАТИЕ CRUNCH]: %%~nxF
        
        rem Вызываем crunch отдельно для каждого файла:
        rem -file "%%F"              : входной файл
        rem -fileformat dds          : принудительный контейнер dds
        rem -dxt3                    : формат DXT3
        rem -mipmode none            : отключаем мипмапы
        rem -out "%CONV_DIR%\%%~nxF" : точный путь и оригинальное имя на выходе
        "%CRUNCH_PATH%" -file "%%i" -fileformat dds -dxt3 -mipmode none -out "%CONV_DIR%\%%~nxi"
        
    )
)

echo.
echo Процесс завершен! Проверьте папку "%CONV_DIR%".
pause