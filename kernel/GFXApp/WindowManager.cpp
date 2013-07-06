#include "Window.h"

static WINDOW* wList[16];

void initWindowManager()
{
	for(int i = 0; i < 16; i++)
	{
		wList[i]->isValid = false;
	}
}

int findFirstFreeSlot()
{
	for(int i = 0; i < 16; i++)
	{
		if(!wList[i]->isValid) return i;
	}
	return -1;
}

int addWindow(WINDOW* w)
{
	if(!w->isValid) return -1;
	w->windowId = findFirstFreeSlot();
	if(w->windowId == -1) return -1;
	wList[w->windowId] = w;
	return w->windowId;
}

void repaintScreen()
{
	for(int i = 0; i < 16; i++)
	{
		if(!wList[i]->isValid)continue;
		wList[i]->paint(wList[i]);
	}
}

WINDOW* getWindowById(char id)
{
	return wList[id];
}

void removeWindow(char id)
{
	wList[id]->isValid = false;
}