@echo off
echo Launching Task1
echo Creating Image
echo Enter file name
set /p FileName=Enter image src name: 
if not exist "src\%FileName%.asm" (
echo SRC file not found
pause
exit
)
if not exist "images" mkdir images
nasm.exe src\%FileName%.asm -o images\boot-%FileName%.img
echo Launcting Image
"C:\Program Files\qemu\qemu-system-i386.exe" "images\boot-%FileName%.img"
pause