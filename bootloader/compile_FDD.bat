@echo off

nasm -f bin Boot1.asm -o Boot1.bin
copy /b Boot1.bin disk.img
nasm -f bin Stage2.asm -o KRNLDR.SYS
copy /b KRNLDR.SYS A:\KRNLDR.SYS
nasm -f bin realmodewrapper.asm -o RMODE.SYS
copy /b RMODE.SYS A:\RMODE.SYS
pause
"C:\Program Files (x86)\Bochs-2.5.1\bochs.exe" -qf test.bxrc
