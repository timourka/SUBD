@echo off
chcp 65001 > nul
setlocal

:: Запрашиваем название коммита
set /p commit_message="Введите название коммита: "

:: Проверяем, находится ли скрипт в репозитории Git
git rev-parse --is-inside-work-tree > nul 2>&1
if %errorlevel% equ 0 (
    :: Добавляем все изменения в индекс Git
    git add .
    
    :: Делаем коммит с заданным сообщением
    git commit -m "%commit_message%"
    
    echo Коммит с названием "%commit_message%" успешно создан.
) else (
    echo Ошибка: скрипт не находится в репозитории Git.
)

endlocal