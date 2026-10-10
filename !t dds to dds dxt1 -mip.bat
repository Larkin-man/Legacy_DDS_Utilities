@echo off
chcp 65001 >nul
cd /d "%~dp0"

:: Создаем папку Out, если её еще нет
if not exist "Out" mkdir "Out"

:: Конвертация в DXT1 (-f BC1_UNORM) без мип-мап (-m 1)
:: -ft dds — жестко указывает тип выходного файла
texconv.exe -f BC1_UNORM -m 1 -ft dds -o "Out" -y *.dds

echo.
echo Конвертация завершена! Мип-мапы отключены.
pause