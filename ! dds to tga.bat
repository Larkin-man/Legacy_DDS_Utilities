@echo off
cd /d "%~dp0"
texconv.exe *.dds -ft tga
pause
