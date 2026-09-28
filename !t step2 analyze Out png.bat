@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

title Этап 2: Анализ альфа-канала

if not exist Out (
    echo ОШИБКА: Папка Out не найдена!
    pause
    exit /b
)

if not exist analyze_alpha.ps1 (
    echo ОШИБКА: Файл analyze_alpha.ps1 не найден!
    pause
    exit /b
)

echo. > conversion_report.txt
echo ============================================================ >> conversion_report.txt
echo  Отчет о безопасности конвертации DXT3 в DXT1 >> conversion_report.txt
echo ============================================================ >> conversion_report.txt
echo. >> conversion_report.txt

set "safe=0"
set "unsafe=0"
set "errors=0"

echo ============================================================
echo  Анализ PNG файлов в папке Out
echo ============================================================
echo.

REM Запускаем PowerShell и подавляем stderr (2>nul)
for /f "delims=" %%r in ('powershell -NoProfile -ExecutionPolicy Bypass -File analyze_alpha.ps1 2^>nul') do (
    set "result=%%r"
    
    REM Проверяем, что строка содержит ":"
    echo !result! | findstr ":" >nul
    if !errorlevel! equ 0 (
        REM Парсим результат: filename.png:STATUS
        for /f "tokens=1,2 delims=:" %%a in ("!result!") do (
            set "filename=%%a"
            set "status=%%b"
            
            echo Анализ: !filename:.png=.dds!
            
            echo ------------------------------------------------------------ >> conversion_report.txt
            echo Файл: !filename:.png=.dds! >> conversion_report.txt
            echo   Формат: DXT3 ^(BC2^) >> conversion_report.txt
            
            if "!status!"=="SAFE" (
                echo   [БЕЗОПАСНО] Альфа полностью непрозрачный
                echo   [БЕЗОПАСНО] Альфа-канал полностью непрозрачный >> conversion_report.txt
                echo   Можно конвертировать в DXT1 без потери качества >> conversion_report.txt
                set /a safe+=1
            ) else if "!status!"=="UNSAFE" (
                echo   [НЕ БЕЗОПАСНО] Есть прозрачность
                echo   [НЕ БЕЗОПАСНО] Есть полупрозрачные пиксели >> conversion_report.txt
                echo   Конвертация в DXT1 приведет к потере качества >> conversion_report.txt
                set /a unsafe+=1
            ) else (
                echo   [ОШИБКА] Не удалось проанализировать
                echo   [ОШИБКА] Не удалось проанализировать >> conversion_report.txt
                set /a errors+=1
            )
            
            echo. >> conversion_report.txt
        )
    )
)

echo. >> conversion_report.txt
echo ============================================================ >> conversion_report.txt
echo  ИТОГО: >> conversion_report.txt
echo  Безопасно конвертировать: !safe! >> conversion_report.txt
echo  Нельзя конвертировать: !unsafe! >> conversion_report.txt
echo  Ошибок: !errors! >> conversion_report.txt
echo ============================================================ >> conversion_report.txt

echo.
echo ============================================================
echo  Анализ завершен!
echo  Безопасно: !safe!
echo  Нельзя: !unsafe!
echo  Ошибок: !errors!
echo  Отчет: conversion_report.txt
echo ============================================================
pause

start notepad.exe conversion_report.txt