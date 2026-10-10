@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

rem Принудительный переход в папку, где лежит сам батник
cd /d "%~dp0"

set "CONV_DIR=Out"
set "REPORT=tga_comparison.txt"

echo =================================================== > "%REPORT%"
echo   ОТЧЕТ ПО СРАВНЕНИЮ ИСХОДНЫХ TGA И ПОЛУЧЕННЫХ DDS >> "%REPORT%"
echo   Дата: %DATE%  Время: %TIME% >> "%REPORT%"
echo =================================================== >> "%REPORT%"
echo. >> "%REPORT%"

echo Начинается анализ соответствия TGA и DDS...

rem Перебираем все tga файлы в текущей папке
for %%F in (*.tga) do (
    set "FILE_NAME=%%~nF"
    
    rem Проверяем, есть ли готовый dds в папке Out
    if exist "%CONV_DIR%\!FILE_NAME!.dds" (
        echo [АНАЛИЗ]: !FILE_NAME!
        echo --------------------------------------------------- >> "%REPORT%"
        echo ФАЙЛ: !FILE_NAME! >> "%REPORT%"
        echo --------------------------------------------------- >> "%REPORT%"
        
        rem Сравниваем исходный TGA и пожатый DDS
        echo [Математическая ошибка сжатия MSE] >> "%REPORT%"
        texdiag.exe compare "%%F" "%CONV_DIR%\!FILE_NAME!.dds" -nologo >> "%REPORT%"
        echo. >> "%REPORT%"
    ) else (
        echo [ПРОПУЩЕНО]: В папке %CONV_DIR% не найден файл !FILE_NAME!.dds
    )
)

echo.
echo Анализ завершен! Результаты в файле "%REPORT%"
pause