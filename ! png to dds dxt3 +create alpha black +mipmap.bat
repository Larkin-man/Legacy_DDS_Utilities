@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

:: Создаем папку Out, если её еще нет
if not exist Out mkdir Out

echo Начинаем замену ЧЕРНЫХ пикселей на прозрачность и конвертацию в DXT3...
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка файла: %%~nxi
    
    :: -transparent black - находит абсолютно черный цвет и делает его прозрачным альфа-каналом
    :: -define dds:compression=dxt3 - сжимает в формат DXT3
    :: -define dds:mipmaps=from-alloc - строит полную пирамиду мип-мапов
    magick.exe "%%~fi" -transparent black -define dds:compression=dxt3 -define dds:mipmaps=from-alloc "Out\%%~ni.dds"
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все файлы сохранены в папку Out.
pause
