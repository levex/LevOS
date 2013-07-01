#ifndef __WINDOW_H_
#define __WINDOW_H_

typedef void (_cdecl *PAINTER)(void*);
typedef void (_cdecl *MOVER)(void*, int, int);

typedef struct {
	PAINTER paint;
	MOVER move;
	void* bigBro;
	bool isValid;
	int startX;
	int startY;
	int endX;
	int endY;
	char windowId;
	char* title;
} WINDOW;

#endif