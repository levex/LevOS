#ifndef __IMAGEVIEWER_H_
#define __IMAGEVIEWER_H_

typedef struct {
	char* filename;
	WINDOW* window;
} W_IMAGEVIEWER;

extern void W_IMAGEVIEWER_paint(WINDOW* w);
extern void W_IMAGEVIEWER_move(WINDOW* w, int x, int y);
extern void W_IMAGEVIEWER_init(W_IMAGEVIEWER* t, WINDOW* w, char* title, char* filename);

#endif