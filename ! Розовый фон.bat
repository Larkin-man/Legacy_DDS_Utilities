@echo off
setlocal disabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем ПОШАГОВУЮ конвертацию в несжатый DDS ARGB (без потери качества)...
echo Вывод готовых иконок производится в папку Out
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка иконки: %%~nxi
    
    :: ШАГ 1: Чисто вырезаем розовый фон на оригинальном разрешении
    magick.exe "%%~fi" -transparent #ff00ff "Out\%%~ni_step1.png"
    
    :: ШАГ 2: Уменьшаем и жестко отсекаем полупрозрачность по порогу 50%
    if exist "Out\%%~ni_step1.png" (
        magick.exe "Out\%%~ni_step1.png" -thumbnail 32x32! -channel A -threshold 50%% +channel "Out\%%~ni_step2.png"

    )
    
    :: ШАГ 3: Сохраняем в DDS БЕЗ СЖАТИЯ (compression=none) и без мип-мапов
    if exist "Out\%%~ni_step2.png" (
        magick.exe "Out\%%~ni_step2.png" -define dds:compression=none -define dds:mipmaps=0 "Out\%%~ni.dds"

    )
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все идеальные несжатые DDS сохранены в Out.
pause
