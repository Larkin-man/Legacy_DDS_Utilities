@echo off
chcp 65001 >nul
cd /d "%~dp0"

if exist "Out" (
    del /q /f /s "Out\*.*" > nul 2>&1
    rd /s /q "Out"
    md "Out"
    echo Папка Out успешно очищена.
) else (
    echo Папка Out не найдена!
)