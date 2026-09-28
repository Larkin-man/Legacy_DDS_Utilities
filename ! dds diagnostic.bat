@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

set "LOG_FILE=_dds_info.txt"

:: Выводим стартовое сообщение в консоль
echo ===================================================================
echo   ПОДРОБНАЯ ДИАГНОСТИКА DDS (ImageMagick)
echo ===================================================================
echo Выполнение запущено. Пожалуйста, подождите...
echo.

:: Очищаем старый лог и пишем заголовок в файл
echo =================================================================== > "%LOG_FILE%"
echo   ПОДРОБНАЯ ДИАГНОСТИКА DDS (ImageMagick)                           >> "%LOG_FILE%"
echo =================================================================== >> "%LOG_FILE%"
echo. >> "%LOG_FILE%"

set "FOUND_DDS=0"

for %%i in (*.dds) do (
    if not "%%~nxi"=="%LOG_FILE%" (
        set "FOUND_DDS=1"
        
        :: Выводим имя текущего файла в консоль, чтобы видеть прогресс
        echo [ОБРАБОТКА]: %%~nxi...
        
        call :process_file "%%i"
    )
)

if "!FOUND_DDS!"=="0" (
    echo В текущей папке файлы с расширением .dds не обнаружены.
    echo В текущей папке файлы с расширением .dds не обнаружены. >> "%LOG_FILE%"
)

echo.
echo Диагностика успешно завершена. Результаты сохранены в %LOG_FILE%

:: Автоматическое открытие готового отчета
start "" "notepad++.exe" "%LOG_FILE%" 2>nul
if errorlevel 1 start "" "%LOG_FILE%"

exit /b

:: ===================================================================
:: ПОДПРОГРАММА СБОРА ДАННЫХ И ЗАПИСИ В ФАЙЛ
:: ===================================================================
:process_file
set "FILE_PATH=%~1"
set "FILE_NAME=%~nx1"

:: Получаем вес файла на диске средствами Windows
set "FILE_BYTES=%~z1"
set /a "KB=!FILE_BYTES! / 1024"
if "!KB!"=="0" set "KB=1"

:: Получаем дату изменения файла
set "FILE_DATE=%~t1"

:: Вытаскиваем свойства ImageMagick за один проход
for /f "usebackq tokens=1,2,3,4,5,6 delims=|" %%a in (`magick.exe identify -format "%%w|%%h|%%z|%%[colorspace]|%%[compression]|%%n" "%FILE_PATH%"`) do (
    set "W=%%a"
    set "H=%%b"
    set "DEPTH=%%c"
    set "SPACE=%%d"
    set "COMP=%%e"
    set "LAYERS=%%f"
)

:: Получаем список активных каналов (rgb / rgba)
set "CHANNELS="
for /f "usebackq tokens=*" %%a in (`magick.exe identify -format "%%[channels]" "%FILE_PATH%"`) do (
    set "CHANNELS=%%a"
)

:: Считаем множитель каналов (3.0 для rgb, 4.0 для rgba)
set "CH_NUM=3.0"
echo !CHANNELS! | findstr /I "a alpha" >nul
if "!errorlevel!"=="0" set "CH_NUM=4.0"

:: Настоящий формат сжатия
set "FMT=Неизвестен"
for /f "usebackq tokens=*" %%a in (`magick.exe identify -format "%%[magick]" "%FILE_PATH%"`) do (
    set "FMT=%%a"
)
if not "!COMP!"=="Undefined" if not "!COMP!"=="" set "FMT=!FMT! (!COMP!)"

:: Формируем красивую комбинированную строку альфа-канала
set "ALPHA_MODE=None (!CHANNELS! !CH_NUM!)"
echo !CHANNELS! | findstr /I "a alpha" >nul
if "!errorlevel!"=="0" set "ALPHA_MODE=Present (!CHANNELS! !CH_NUM!)"

:: Записываем структурированный блок параметров в текстовый файл
echo Файл: !FILE_NAME! >> "%LOG_FILE%"
echo        width = !W! >> "%LOG_FILE%"
echo       height = !H! >> "%LOG_FILE%"
echo        depth = !DEPTH! >> "%LOG_FILE%"
echo    mipLevels = !LAYERS! >> "%LOG_FILE%"
echo    arraySize = 1 >> "%LOG_FILE%"
echo       format = !FMT! >> "%LOG_FILE%"
echo    dimension = 2D >> "%LOG_FILE%"
echo   alpha mode = !ALPHA_MODE! >> "%LOG_FILE%"
echo       images = !LAYERS! >> "%LOG_FILE%"
echo   pixel size = !KB! (KB) >> "%LOG_FILE%"
echo     modified = !FILE_DATE! >> "%LOG_FILE%"
echo =================================================================== >> "%LOG_FILE%"

exit /b
