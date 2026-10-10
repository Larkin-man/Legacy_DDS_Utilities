@echo off
chcp 65001 >nul
cd /d "%~dp0"
texconv.exe *.dds -ft png -o Out -y
echo.
pause