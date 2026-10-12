@echo off
setlocal disabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем ПОШАГОВУЮ очистку подложки и конвертацию в несжатый DDS ARGB...
echo Вывод готовых иконок производится в папку Out
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка иконки: %%~nxi
    
    :: ШАГ 1: Делаем розовый цвет фона прозрачным
    magick.exe "%%~fi" -transparent #ff00ff "Out\%%~ni_step1.png"
    
    :: ШАГ 2: Вычищаем розовый из RGB-каналов большой картинки, заменяя его на черный
    if exist "Out\%%~ni_step1.png" (
        magick.exe "Out\%%~ni_step1.png" -background black -alpha background "Out\%%~ni_step2.png"
    )
    
    :: ШАГ 3: Безопасно уменьшаем до 32x32 и жестко отсекаем полупрозрачность по порогу 50%
    if exist "Out\%%~ni_step2.png" (
        magick.exe "Out\%%~ni_step2.png" -thumbnail 32x32! -channel A -threshold 50%% +channel "Out\%%~ni_step3.png"
    )
    
    :: ФИКС КАНАЛОВ: Повторно зачищаем скрытый мусорный цвет после ресайза, заливая его черным
    if exist "Out\%%~ni_step3.png" (
        magick.exe "Out\%%~ni_step3.png" -background black -alpha background "Out\%%~ni_step4.png"
    )
    
    :: ШАГ 4: Запекаем результат в идеальный несжатый DDS ARGB без мип-мапов
    if exist "Out\%%~ni_step4.png" (
        magick.exe "Out\%%~ni_step4.png" -define dds:compression=none -define dds:mipmaps=0 "Out\%%~ni_argb.dds"
    )
	 
	 :: ШАГ 5: Пережимаем идеальный несжатый DDS ARGB в легкий формат DXT1 без мип-мапов
    if exist "Out\%%~ni_argb.dds" (
        magick.exe "Out\%%~ni_argb.dds" -define dds:compression=dxt1 -define dds:mipmaps=0 "Out\%%~ni.dds"
    )
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все идеальные несжатые DDS сохранены в Out.
pause