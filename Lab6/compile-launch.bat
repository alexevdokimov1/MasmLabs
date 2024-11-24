@echo off
chcp 65001
echo Запуск файла
echo Создание образа
set /p FileName=Введите имя файла-источника: 
if not exist "src\%FileName%.asm" (
echo Файл-источник не найден
pause
exit
)
if not exist "images" mkdir images
nasm.exe src\%FileName%.asm -o images\boot-%FileName%.img
echo Запуск образа
"C:\Program Files\qemu\qemu-system-i386.exe" "images\boot-%FileName%.img"
pause