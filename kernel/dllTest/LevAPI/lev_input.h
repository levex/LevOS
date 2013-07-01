#ifndef __LEV_KYBRD_H_
#define __LEV_KYBRD_H_

typedef struct {
	int mx;
	int my;
} MOUSE_STATE;

DLLIMPORT char _cdecl getInputChar();
DLLIMPORT void _cdecl fillMouseState(MOUSE_STATE* m);
DLLIMPORT void waitForKeyPress();

#endif