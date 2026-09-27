@echo off
cd /d "%~dp0"
for %%i in (*.dds) do (
    nvdxt.exe -file "%%i" -u8888
)
pause
