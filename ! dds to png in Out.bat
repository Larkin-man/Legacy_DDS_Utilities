@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Этап 1: Конвертация DXT3 в PNG

if not exist texconv.exe (
    echo ОШИБКА: texconv.exe не найден!
    pause
    exit /b
)

if not exist texdiag.exe (
    echo ОШИБКА: texdiag.exe не найден!
    pause
    exit /b
)

if not exist Out mkdir Out

echo ============================================================
echo  Конвертация DXT3 файлов в PNG
echo ============================================================
echo.

set "count=0"

for %%f in (*.dds) do (
    echo Проверяю: %%f
    
    REM Проверяем формат
    set "is_dxt3=0"
    for /f "tokens=*" %%a in ('texdiag.exe info "%%f" 2^>^&1 ^| findstr "format ="') do (
        echo %%a | findstr /i "BC2" >nul
        if !errorlevel! equ 0 set "is_dxt3=1"
    )
    
    if !is_dxt3! equ 1 (
        echo   Формат: DXT3 - конвертирую в PNG...
        texconv.exe -nologo -ft png -o Out "%%f" >nul 2>&1
        if exist "Out\%%~nf.png" (
            echo   [OK] Создан Out\%%~nf.png
            set /a count+=1
        ) else (
            echo   [ОШИБКА] Не удалось создать PNG
        )
    ) else (
        echo   Формат не DXT3 - пропускаю
    )
)

echo.
echo ============================================================
echo  Готово! Создано PNG файлов: !count!
echo ============================================================
pause