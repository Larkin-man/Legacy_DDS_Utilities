@echo off
chcp 65001 >nul
cd /d "%~dp0"
for %%i in (*.png *.tga) do (
    nvdxt.exe -file "%%i" -dxt3 -nomipmap -outdir Out
)
pause