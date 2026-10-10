@echo off
setlocal disabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

echo Начинаем ПОШАГОВУЮ очистку и финальную конвертацию в DDS DXT1a...
echo Все промежуточные шаги сохраняются в папке Out!
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка иконки: %%~nxi
    
    :: ШАГ 1: Делаем 7f7f7f цвет фона прозрачным
    magick.exe "%%~fi" -transparent #7f7f7f "Out\%%~ni_step1.png"
    
    :: ШАГ 2: Вычищаем 7f7f7f из RGB-каналов большой картинки, заменяя его на черный
    if exist "Out\%%~ni_step1.png" (
        magick.exe "Out\%%~ni_step1.png" -background black -alpha background "Out\%%~ni_step2.png"
        rem del "Out\%%~ni_step1.png"
    )
    
    :: ШАГ 3: Безопасно уменьшаем до 32x32 и жестко отсекаем полупрозрачность по порогу 50%
    if exist "Out\%%~ni_step2.png" (
        magick.exe "Out\%%~ni_step2.png" -thumbnail 32x32! -channel A -threshold 50%% +channel "Out\%%~ni_step3.png"
        rem del "Out\%%~ni_step2.png"
    )
    
    :: ФИКС КАНАЛОВ: Повторно зачищаем скрытый мусорный цвет после ресайза, заливая его черным
    if exist "Out\%%~ni_step3.png" (
        magick.exe "Out\%%~ni_step3.png" -background black -alpha background "Out\%%~ni_step4.png"
        rem del "Out\%%~ni_step3.png"
    )
    
    :: ШАГ 4: Запекаем результат в идеальный, чистый, несжатый DDS ARGB без мип-мапов
    if exist "Out\%%~ni_step4.png" (
        magick.exe "Out\%%~ni_step4.png" -define dds:compression=none -define dds:mipmaps=0 "Out\%%~ni_argb.dds"
        rem del "Out\%%~ni_step4.png"
    )
    
    :: ШАГ 5: Используем -define dds:compression=dxt1a для принудительной 1-битной альфы
    if exist "Out\%%~ni_argb.dds" (
        magick.exe "Out\%%~ni_argb.dds" -define dds:compression=dxt1a -define dds:mipmaps=0 "Out\%%~ni.dds"
    )
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все шаги и финальные DXT1a DDS лежат в Out.
pause