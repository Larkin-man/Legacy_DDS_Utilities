@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем замену ЧЕРНЫХ пикселей на бинарную прозрачность. Выход DXT1 без мип-мапов...
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка файла: %%~nxi
    
    :: -transparent black - вырезает черный цвет #7f7f7f-серый
    :: -define dds:compression=dxt1 - жмет в легкий DXT1 с поддержкой 1-битной прозрачности
    :: -define dds:mipmaps=0 - отключает мип-мапы
    magick.exe "%%~fi" -transparent black -define dds:compression=dxt1 -define dds:mipmaps=0 "Out\%%~ni.dds"
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все легкие файлы DXT1 сохранены в папку Out.
pause