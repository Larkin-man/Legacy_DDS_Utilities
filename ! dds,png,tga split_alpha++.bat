@echo off
chcp 65001 >nul
cd /d "%~dp0"
setlocal enabledelayedexpansion

if not exist "Out" mkdir "Out"

for %%F in (*.png *.tga *.dds) do (
    echo Обработка: %%F
    
    :: Получаем список активных каналов (используем ваш проверенный синтаксис с двумя %%)
    set "CHANNELS="
    for /f "usebackq tokens=*" %%a in (`magick.exe identify -format "%%[channels]" "%%F" 2^>nul`) do (
        set "CHANNELS=%%a"
    )
    
    :: Считаем множитель каналов (3.0 для rgb, 4.0 для rgba)
    set "CH_NUM=3.0"
    echo !CHANNELS! | findstr /I "a alpha" >nul
    if "!errorlevel!"=="0" set "CH_NUM=4.0"
    
    :: Формируем статус альфа-канала
    set "ALPHA_MODE=None (!CHANNELS! !CH_NUM!)"
    echo !CHANNELS! | findstr /I "a alpha" >nul
    if "!errorlevel!"=="0" set "ALPHA_MODE=Present (!CHANNELS! !CH_NUM!)"
    
    echo Статус альфы: !ALPHA_MODE!    
    :: Финальное ветвление на основе вычисленного CH_NUM
    if "!CH_NUM!"=="4.0" (
        echo [INFO] Альфа-канал НАЙДЕН. Разделяем каналы...
        magick "%%F" -alpha extract "Out\%%~nF_alpha.png"
        magick "%%F" -alpha off "Out\%%~nF_color%%~xF"
        echo [OK] Успешно разделено.
    ) else (
        echo [WARN] Альфа-канал НЕ найден. Копируем только цвет.
        magick "%%F" -alpha off "Out\%%~nF_color%%~xF"
    )
    
    echo ---------------------------------------
)

echo.
echo Готово! Все файлы обработаны.
pause
