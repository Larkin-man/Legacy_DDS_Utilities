@echo off
chcp 65001 >nul
cd /d "%~dp0"
for %%i in (*.dds) do (
    nvdxt.exe -file "%%i" -dxt1a -nomipmap -outdir Out
)
pause