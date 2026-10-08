@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

if not exist "Out" mkdir "Out"

for %%F in (*.png *.tga *.dds) do (
    echo Обработка: %%F
    
    :: 1. Извлекаем альфа-канал в ч/б PNG-маску
    magick "%%F" -alpha extract "Out\%%~nF_alpha.png"
	 :: 2. Сохраняем цветную подложку без альфа-канала в исходном формате
    magick "%%F" -alpha off "Out\%%~nF_color%%~xF"
    
    echo [OK] Файл обработан.
    echo ---------------------------------------
)

echo.
echo Готово! Все файлы разделены и сохранены в папку Out.
pause