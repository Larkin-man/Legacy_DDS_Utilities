@echo off
chcp 65001 > nul

rem Переходим в папку Out, которая лежит рядом с батником
cd /d "%~dp0Out" 2>nul

if %errorlevel% equ 0 (
    echo Удаление файлов из папки Out...
    
    rem Удаляем файлы dds, png, tga только в этой папке
    del /f /q *.dds *.png *.tga 2>nul
    
    echo Готово!
) else (
    echo Ошибка: Папка "Out" не найдена рядом с этим файлом.
)