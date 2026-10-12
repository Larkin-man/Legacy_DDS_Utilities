@echo off
chcp 65001 >nul
cd /d "%~dp0"

:: Создаем папку Out, если её еще нет
if not exist "Out" mkdir "Out"

:: -f BC2_UNORM — современный аналог сжатия DXT3
:: -m 1 — отключает генерацию мипмапов
:: -ft dds — жестко указывает тип выходного файла
:: -y — перезаписывает файл в папке Out, если он там уже есть
echo Начинаю конвертацию всех DDS в формат DXT3 BC2...
texconv.exe -f BC2_UNORM -bcuniform -m 1 -y -o "Out" *.dds


echo.
echo Готово! Все файлы обработаны.
pause