@echo off
cd /d "%~dp0"
texconv.exe *.dds -ft tga -o Out -y
echo.
pause