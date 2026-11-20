@echo off
chcp 65001 >nul
cd /d "%~dp0"

rem --- ищем Python ---
set PY=
where python >nul 2>nul && set PY=python
if "%PY%"=="" (where py >nul 2>nul && set PY=py)
if "%PY%"=="" (
    echo [ОШИБКА] Python не найден.
    echo Скачайте Python 3.13 с https://www.python.org/downloads/
    echo При установке обязательно поставьте галочку "Add Python to PATH".
    pause
    exit /b 1
)

rem --- окружение: если нет рабочего, создаём заново ---
if not exist ".venv\Scripts\python.exe" (
    if exist ".venv" rmdir /s /q ".venv"
    echo Создаю окружение...
    %PY% -m venv .venv
    if errorlevel 1 (
        echo [ОШИБКА] Не удалось создать окружение.
        pause
        exit /b 1
    )
)

echo Ставлю библиотеки...
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo [ОШИБКА] Не удалось установить библиотеки. Проверьте интернет.
    pause
    exit /b 1
)

start "" cmd /c "timeout /t 4 >nul & start http://localhost:8000"
echo Сервер запущен: http://localhost:8000   Закрыть: Ctrl+C
".venv\Scripts\python.exe" run.py
pause
