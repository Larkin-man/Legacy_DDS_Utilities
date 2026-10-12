@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

rem Принудительный переход в папку, где лежит сам батник и ваши текстуры
cd /d "%~dp0"

rem Укажите здесь актуальный путь к вашему новому crunch.exe
set "CRUNCH_PATH=C:\INSTALL\crunch-master\bin\crunch.exe"
set "CONV_DIR=Out"

rem Создаем папку Out, если её еще нет
if not exist "%CONV_DIR%" mkdir "%CONV_DIR%"

echo ===================================================
echo   ТЕСТИРОВАНИЕ НОВОГО DAEMONENGINE CRUNCH (v1.04U)
echo ===================================================
echo.

rem 1. Проверяем версию утилиты и выводим встроенную справку
echo [ПРОВЕРКА ВЕРСИИ]:
"%CRUNCH_PATH%" -version
if errorlevel 1 (
    rem Если флаг -version не поддерживается, вызовем справку
    "%CRUNCH_PATH%" --help
)
echo.
echo ---------------------------------------------------
echo Начинается сжатие файлов с максимальным качеством...
echo ---------------------------------------------------
echo.

rem 2. Запускаем пакетную конвертацию файлов
rem Используем маску *.dds для обработки всех иконок в один проход
"%CRUNCH_PATH%" -file *.dds -dxt3 -quality 100 -mipmode none -out "%CONV_DIR%"

echo.
echo Конвертация завершена. Проверьте папку "%CONV_DIR%".
echo Теперь можно запустить ваш проверочный скрипт сравнения качества.
echo.
pause
