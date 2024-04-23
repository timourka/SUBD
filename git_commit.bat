@echo off
chcp 65001 > nul
setlocal

:: Запрашиваем название коммита
set /p commit_message="Введите название коммита: "

:: Запрашиваем имя ветки с помощью значения по умолчанию 'main'
set /p branch_name="Введите имя ветки (по умолчанию 'main'): " || set branch_name=main

:: Проверяем, находится ли скрипт в репозитории Git
git rev-parse --is-inside-work-tree > nul 2>&1
if %errorlevel% equ 0 (
    :: Добавляем все изменения в индекс Git
    git add .
    
    :: Делаем коммит с заданным сообщением
    git commit -m "%commit_message%"
    
    :: Отправляем коммит в удаленное хранилище на указанную ветку
    git push origin %branch_name%
    
    echo Коммит с названием "%commit_message%" успешно отправлен в удаленное хранилище на ветку "%branch_name%".
) else (
    echo Ошибка: скрипт не находится в репозитории Git.
)

pause

endlocal
