@echo off
cd /d "%~dp0"
texconv.exe *.dds -ft png -o Out -y
echo.
pause