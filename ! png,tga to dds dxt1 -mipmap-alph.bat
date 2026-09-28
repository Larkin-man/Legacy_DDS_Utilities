@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

:: Создаем папку Out, если её еще нет
if not exist Out mkdir Out

echo Начинаем конвертацию PNG/TGA -> DDS DXT1 ^(без мип-мапов и альфы^)...
echo -------------------------------------------------------------------

:: Цикл ищет все файлы PNG и TGA в текущей папке
for %%i in (*.png *.tga) do (
    echo Обработка исходника: %%~nxi
    
    :: -alpha off - принудительно удаляет прозрачность из PNG/TGA
    :: dds:compression=dxt1 - сжимает в формат DXT1
    :: dds:mipmaps=0 - отключает генерацию мип-мапов
    magick.exe "%%~fi" -alpha off -define dds:compression=dxt1 -define dds:mipmaps=0 "Out\%%~ni.dds"
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все файлы DXT1 сохранены в папку Out.
pause
