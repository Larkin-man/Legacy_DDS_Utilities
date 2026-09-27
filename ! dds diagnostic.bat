@echo off
chcp 65001 >nul
title Сбор информации о DDS

set "LOG=dds_info.txt"

if not exist texdiag.exe (
    echo ОШИБКА: texdiag.exe не найден!
    pause
    exit
)

echo Сбор информации...

echo. > "%LOG%"
echo ============================================================ >> "%LOG%"
echo  Информация о DDS файлах >> "%LOG%"
echo ============================================================ >> "%LOG%"
echo. >> "%LOG%"

for %%f in (*.dds) do (
    echo Обработка: %%f
    echo ------------------------------------------------------------ >> "%LOG%"
    echo Файл: %%f >> "%LOG%"
    texdiag.exe info "%%f" >> "%LOG%" 2>&1
    echo. >> "%LOG%"
)

echo. >> "%LOG%"
echo ============================================================ >> "%LOG%"
echo Готово! >> "%LOG%"
echo ============================================================ >> "%LOG%"

echo.
echo Информация сохранена в %LOG%
echo.
echo Нажмите любую клавишу для открытия файла...
pause >nul

start notepad.exe "%LOG%"