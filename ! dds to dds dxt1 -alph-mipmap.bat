@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
cd /d "%~dp0"

:: Создаем папку Out, если её еще нет
if not exist Out mkdir Out

:: Экранируем спецсимволы ^( ^) и цифру перед стрелкой ^1^> чтобы не создавался левый файл
echo Начинаем конвертацию DDS - ^(без мип-мапов и альфы^)...
echo -------------------------------------------------------------------

for %%i in (*.dds) do (
    :: Безопасная проверка пути без использования капризных findstr в цикле
    set "CURRENT_FILE=%%~fi"
    
    :: Проверяем, не лежит ли файл уже в папке Out
    echo !CURRENT_FILE! | findstr /I "\\Out\\" >nul
    if errorlevel 1 (
        echo Обработка файла: %%~nxi        
		  :: -alpha off - принудительно полностью вырезает альфа-канал
        :: dds:compression=dxt1 - задает сжатие в формат DXT1
        :: dds:mipmaps=0 - полностью отключает создание мип-мапов
        magick.exe "%%~fi" -alpha off -define dds:compression=dxt1 -define dds:mipmaps=0 "Out\%%~ni.dds"
    )
)

echo -------------------------------------------------------------------
echo Оптимизация завершена! Все легкие DXT1 файлы сохранены в папку Out.
pause
