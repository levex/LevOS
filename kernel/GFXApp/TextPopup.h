#ifndef __TEXTPOPUP_H_
#define __TEXTPOPUP_H_

typedef struct {
	char* text;
	WINDOW* window;
} W_TEXTPOPUP;

extern void W_TEXTPOPUP_paint(WINDOW* w);
extern void W_TEXTPOPUP_move(WINDOW* w, int x, int y);
extern void W_TEXTPOPUP_init(W_TEXTPOPUP* t, WINDOW* w, char* title, char* str);

#endif