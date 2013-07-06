#include "Window.h"
#include "TextPopup.h"
#include "string.h"
#include "..\dllTest\LevAPI\lev_vga.h"
void OUTc(char a)
{
		_asm mov dx, 0xE9
		_asm mov al, a
		_asm out dx, al
}

void W_TEXTPOPUP_paint(WINDOW* w)
{
	char c = VGA_getcolor();
	VGA_setcolor(1);
	/* WINDOW PRIMITIVE */
	VGA_putrect(w->startX, w->startY, w->endX, w->startY + 12);
	VGA_putstring(w->startX + 2 , w->startY + 2, w->title);
	VGA_putrect(w->startX, w->startY, w->endX, w->endY);
	/* END WINDOW PRIMITIVE */
	VGA_putstring(w->startX + 2, (w->startY + w->endY) / 2, ((W_TEXTPOPUP*)(w->bigBro))->text);
	VGA_setcolor(c);
}

void W_TEXTPOPUP_move(WINDOW* w, int x, int y)
{
	/* save me */
	//OUTc('C');
	int width = w->endX - w->startX;
	int height = w->endY - w->startY;
	/* clear me */

	char c = VGA_getcolor();
	VGA_setcolor(0);
	VGA_putrect(w->startX, w->startY, w->endX, w->startY + 12);
	VGA_putstring(w->startX + 2 , w->startY + 2, w->title);
	VGA_putrect(w->startX, w->startY, w->endX, w->endY);
	/* END WINDOW PRIMITIVE */
	VGA_putstring(w->startX + 2, (w->startY + w->endY) / 2, ((W_TEXTPOPUP*)(w->bigBro))->text);

	/* redraw move */
	w->startX = x;
	w->startY = y;
	w->endX = w->startX + width;
	w->endY = w->startY + height;
	return;
}

void W_TEXTPOPUP_init(W_TEXTPOPUP* t, WINDOW* w, char* title, char* str)
{
	t->text = str;
	w->startX = 45;
	w->startY = 45;
	w->endX = w->startX + (strlen(t->text) + 1)*8;
	w->endY = w->startY + 45;
	w->isValid = true;
	w->title = title;
	w->paint = (void(__cdecl*)(void*))W_TEXTPOPUP_paint;
	w->move = (void(__cdecl*)(void*, int, int))W_TEXTPOPUP_move;
	w->bigBro = t;
	t->window = w;
}