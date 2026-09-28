@echo off
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем конвертацию в DDS DXT3 с мип-мапами (вывод в папку Out)...
echo -------------------------------------------------------

for %%i in (*.png *.tga) do (
    echo Сборка текстуры: %%~nxi
    magick.exe "%%i" -define dds:compression=dxt3 -define dds:mipmaps=from-alloc "Out\%%~ni.dds"
)

echo -------------------------------------------------------
echo Конвертация завершена! Все файлы сохранены в папку Out.
pause
