@echo off
setlocal disabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

if not exist Out mkdir Out

:: Прописываем путь к утилите NVIDIA согласно настройкам
set "NVTT_PATH=C:\INSTALL\NVIDIA Texture Tools"
set "CRUNCH_PATH=C:\INSTALL\crunch-master\bin\crunch.exe"
set "CONV_DIR=Out"

echo Начинаем ПОШАГОВУЮ очистку, ресайз и сжатие в DDS DXT3 через NVIDIA Texture Tools...
echo Все промежуточные шаги сохраняются в папке Out!
echo -------------------------------------------------------------------

for %%i in (*.png) do (
    echo Обработка иконки: %%~nxi
    
    :: ШАГ 1: Делаем 7f7f7f цвет фона прозрачным на исходном разрешении
    magick.exe "%%~fi" -transparent #7f7f7f "Out\%%~ni_step1.png"
    
    :: ШАГ 2: Первичная очистка — заменяем скрытый 7f7f7f цвет в RGB-каналах на черный
    if exist "Out\%%~ni_step1.png" (
        magick.exe "Out\%%~ni_step1.png" -background black -alpha background "Out\%%~ni_step2.png"
        rem del "Out\%%~ni_step1.png"
    )
    
    :: ШАГ 3: Уменьшаем до 32x32 и жестко отсекаем полупрозрачность по порогу 50%
    if exist "Out\%%~ni_step2.png" (
        magick.exe "Out\%%~ni_step2.png" -thumbnail 32x32! -channel A -threshold 50%% +channel "Out\%%~ni_step3.png"
        rem del "Out\%%~ni_step2.png"
    )
    
    :: ШАГ 4: ФИКС КАНАЛОВ — повторно зачищаем скрытый мусорный цвет после ресайза, заливая его черным
    if exist "Out\%%~ni_step3.png" (
        magick.exe "Out\%%~ni_step3.png" -background black -alpha background "Out\%%~ni_step4.png"
        rem del "Out\%%~ni_step3.png"
    )
    
    :: ШАГ 5: Запекаем результат в эталонный, чистый, несжатый DDS ARGB без потери данных
    if exist "Out\%%~ni_step4.png" (
        magick.exe "Out\%%~ni_step4.png" -define dds:compression=none -define dds:mipmaps=0 "Out\%%~ni_argb.dds"
        rem del "Out\%%~ni_step4.png"
    )
    
    :: ШАГ 6 (ФИНАЛЬНЫЙ): 
    if exist "Out\%%~ni_argb.dds" (
		
		rem Вызываем crunch отдельно для каждого файла:
        rem -file "%%i"              : входной файл
        rem -fileformat dds          : принудительный контейнер dds
        rem -dxt3                    : формат DXT3
        rem -mipmode none            : отключаем мипмапы
        rem -out "%CONV_DIR%\%%~nxF" : точный путь и оригинальное имя на выходе
        "%CRUNCH_PATH%" -file "Out\%%~ni_argb.dds" -fileformat dds -dxt3 -mipmode none -out "%CONV_DIR%\%%~ni_2.dds"
		  
			:: Сжимаем чистый ARGB в текстуру DXT3 через алгоритмы NVIDIA
        pushd "%NVTT_PATH%"
        :: --format bc2 — кодек NVIDIA для сжатия в качественный DXT3 (Explicit Alpha)
        :: --quality production — максимальное качество обработки блоков пикселей
        :: --no-mips — генерация мип-мапов отключена для четкости интерфейса
        nvtt_export.exe "%~dp0Out\%%~ni_argb.dds" --format bc2 --quality production --no-mips --output "%~dp0Out\%%~ni.dds"
        popd
    )
)

echo -------------------------------------------------------------------
echo Конвертация завершена! Все шаги и финальные DXT3 DDS лежат в Out.
pause
