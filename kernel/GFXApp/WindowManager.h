#ifndef __WINDOWMANAGER_H_
#define __WINDOWMANAGER_H_

extern int addWindow(WINDOW w);
extern void repaintScreen();
extern void removeWindow(char id);
extern WINDOW* getWindowById(char id);

#endif