#include "..\LevAPI\lev_vga.h"
#include "..\LevAPI\lev_text.h"
#include "..\LevAPI\lev_input.h"
#include "string.h"
#include "Window.h"
#include "TextPopup.h"
#include "WindowManager.h"

#ifndef OUT_A
#define OUT_A
	void OUT(char a)
	{
			_asm mov dx, 0xE9
			_asm mov al, a
			_asm out dx, al
	}
#endif


void main()
{
	print("\nGfx init...");
	while(getInputChar() == 0);
	VGA_init();
	VGA_putimage(16, 16, "test.bmp");
	while(getInputChar() == 0);
	VGA_clear();
	//VGA_putstring(16, 160, "string printing WORKING");
	char c = 0;
	int x = 0, y = 0;
	//VGA_putrect(16, 16, 250, 450);
	MOUSE_STATE m;
	int mx = 0; int my = 0;
	int timeout = 100000;
	W_TEXTPOPUP tp;
	WINDOW w;
	W_TEXTPOPUP_init(&tp, &w, "LevOS 2.0" ,"Levex is an epic developer!");
	//w.title = "Levex Popup";
	w.move(&w, 120, 120);

	addWindow(w);
	WINDOW* wp;
	w = *getWindowById(w.windowId);

	while(true)
	{
		repaintScreen();
		c = getInputChar();
		if(c == 0) continue;
		VGA_putchar(x += 8, y, c);
		//printHexa(c);
		//if(c == 0xD){ y += 8; x = 0; continue; }
		if(c == 0x64) {  w.move(&w, w.startX + 16, w.startY);  continue; } // d
		if(c == 0x61) { /*wp->move(wp, wp->startX - 16,  wp->startY);*/ continue; } // a
		if(c == 0x77) { /*wp->move(wp, wp->startX,wp->startY - 16); */continue; } // w
		if(c == 0x73) {/* wp->move(wp, wp->startX,wp->startY + 16); */continue; } // s
		/*if(c == 0x08) //bksp
		{
			x -= 8;
			VGA_putchar(x, y, ' ');
			continue;
		}
		VGA_putchar(x, y, c);
		x += 8;*/
	}
	//getInputChar();
	VGA_deinit();
}