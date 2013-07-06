#ifndef __WINDOW_H_
#define __WINDOW_H_

extern void OUT(char a);

typedef struct {
	void (*paint)(void* w);
	void (*move)(void* w, int x, int y);
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