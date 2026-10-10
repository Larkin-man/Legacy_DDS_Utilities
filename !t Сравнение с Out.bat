@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

rem Принудительный переход в папку, где лежит сам батник
cd /d "%~dp0"

set "CONV_DIR=Out"
set "DIFF_DIR=Diff_Maps"
set "REPORT=comparison_report.txt"

if not exist "%DIFF_DIR%" mkdir "%DIFF_DIR%"

echo =================================================== > "%REPORT%"
echo   ОТЧЕТ ПО СРАВНЕНИЮ КАРТИНКИ-ОРИГИНАЛА И КОПИИ >> "%REPORT%"
echo   Дата: %DATE%  Время: %TIME% >> "%REPORT%"
echo =================================================== >> "%REPORT%"
echo. >> "%REPORT%"

echo Начинается точечный анализ форматов TGA, PNG, DDS...

rem Перебираем только нужные расширения
for %%E in (tga png dds) do (
    for %%F in (*.%%E) do (
        set "ATTR=%%~aF"
        if not "!ATTR:~0,1!"=="d" (
            
            set "NAME_ONLY=%%~nF"
            set "ORIG_EXT=%%~xF"
            
            echo [ОБРАБОТКА]: %%~nxF
            set "TARGET_COPY="
            
            rem Безопасная последовательная проверка существования файлов
            if exist "%CONV_DIR%\%%~nF%%~xF" set "TARGET_COPY=%CONV_DIR%\%%~nF%%~xF"
            if exist "%CONV_DIR%\%%~nF.dds" set "TARGET_COPY=%CONV_DIR%\%%~nF.dds"
            if exist "%CONV_DIR%\%%~nF.tga" set "TARGET_COPY=%CONV_DIR%\%%~nF.tga"
            if exist "%CONV_DIR%\%%~nF.png" set "TARGET_COPY=%CONV_DIR%\%%~nF.png"
            
            rem Если копия найдена, выполняем диагностику
            if defined TARGET_COPY (
                echo --------------------------------------------------- >> "%REPORT%"
                echo ОРИГИНАЛ: %%~nxF ^| КОПИЯ: !TARGET_COPY! >> "%REPORT%"
                echo --------------------------------------------------- >> "%REPORT%"
                
                texdiag.exe info "%%F" -nologo >> "%REPORT%" 2>&1
                texdiag.exe info "!TARGET_COPY!" -nologo >> "%REPORT%" 2>&1
                
                echo [Результат сравнения пикселей MSE Error] >> "%REPORT%"
                texdiag.exe compare "%%F" "!TARGET_COPY!" -nologo >> "%REPORT%" 2>&1
                echo. >> "%REPORT%"
                
                texdiag.exe diff "%%F" "!TARGET_COPY!" -o "%DIFF_DIR%\diff_%%~nF.dds" -y -nologo > nul 2>&1
            )
        )
    )
)

echo.
echo Анализ завершен! Открываю отчет...

rem Пытаемся запустить Notepad++
start "" "notepad++.exe" "%REPORT%" 2>nul

rem Проверяем, запустился ли процесс notepad++.exe. Если нет (errorlevel не 0), открываем обычный блокнот
if errorlevel 1 (
    start notepad.exe "%REPORT%"
)

pause