@echo off
for %%i in (*.png *.tga) do (
    nvdxt.exe -file "%%i" -dxt3 -nomipmap
)
pause
