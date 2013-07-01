@echo off
nasm -f bin Boot1.asm -o Boot1.bin
copy /b Boot1.bin disk.img
nasm -f bin Stage2.asm -o KRNLDR.SYS
pause
echo Creating hdd0.vhd
"C:\Users\Levex\Desktop\LevOS\rewrite2\dd.exe" if="C:\Users\Levex\Desktop\LevOS\rewrite2\hdd\disk.img" of="C:\Users\Levex\Desktop\LevOS\rewrite2\hdd\hdd.img" bs=512 count=1
pause
echo Starting bochs...
pause
"C:\Program Files (x86)\Bochs-2.5.1\bochs.exe" -qf test.bxrc
pause