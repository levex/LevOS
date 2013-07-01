[bits 16]
[section .text]
switch_video_mode:
	mov ax, 13h
	int 10h