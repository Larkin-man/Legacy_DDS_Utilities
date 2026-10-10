@echo off
chcp 65001 >nul
cd /d "%~dp0"

if not exist texdiag.exe (
    echo ОШИБКА: texdiag.exe не найден!
    pause
    exit
)

title Сбор информации о DDS

set "LOG=_diag_info.txt"

echo Сбор информации о DDS...

echo ============================================================ > "%LOG%"
echo  Информация о DDS файлах >> "%LOG%"
echo ============================================================ >> "%LOG%"

texdiag.exe info *.dds >> "%LOG%" 2>&1

echo ============================================================ >> "%LOG%"
echo Готово! >> "%LOG%"
echo ============================================================ >> "%LOG%"

echo.
echo Информация сохранена в %LOG%
echo.
echo Нажмите любую клавишу для открытия файла...
pause >nul

start notepad++.exe "%LOG%"