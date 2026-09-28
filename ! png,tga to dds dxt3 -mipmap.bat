@echo off
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем конвертацию в DDS DXT3 БЕЗ МИП-МАПОВ (вывод в папку Out)...
echo -------------------------------------------------------

for %%i in (*.png *.tga) do (
    echo Сборка (без мип-мапов): %%~nxi
    :: Опция dds:mipmaps=0 полностью отключает создание пирамиды уровней
    magick.exe "%%i" -define dds:compression=dxt3 -define dds:mipmaps=0 "Out\%%~ni.dds"
)

echo -------------------------------------------------------
echo Конвертация завершена! Все файлы сохранены в папку Out.
pause
