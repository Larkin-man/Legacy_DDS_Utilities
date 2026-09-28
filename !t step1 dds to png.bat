@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

title Этап 1: Конвертация всех DXT кроме DXT1 в PNG

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
set "skipped=0"

for %%f in (*.dds) do (
    echo Проверяю: %%f
    
    REM Проверяем формат
    set "i_dxt1=0"
    for /f "tokens=*" %%a in ('texdiag.exe info "%%f" 2^>^&1 ^| findstr "format ="') do (
        echo %%a | findstr /i "BC1" >nul
        if !errorlevel! equ 0 set "i_dxt1=1"
    )
    
    if !i_dxt1! equ 0 (
        echo   Формат: Не DXT1 - конвертирую в PNG...
        texconv.exe -nologo -ft png -o Out "%%f" >nul 2>&1
        if exist "Out\%%~nf.png" (
            echo   [OK] Создан Out\%%~nf.png
            set /a count+=1
        ) else (
            echo   [ОШИБКА] Не удалось создать PNG
        )
    ) else (
        echo   Формат DXT1 - пропускаю
		  set /a skipped+=1
    )
)

echo.
echo ============================================================
echo  Готово! Создано PNG файлов: !count!
echo  Пропущено (DXT1): !skipped!
echo ============================================================
pause