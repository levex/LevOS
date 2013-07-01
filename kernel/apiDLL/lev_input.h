#ifndef __LEV_KYBRD_H_
#define __LEV_KYBRD_H_

typedef struct {
	int mx;
	int my;
} MOUSE_STATE;

DLLEXPORT char _cdecl getInputChar();
DLLEXPORT void _cdecl fillMouseState(MOUSE_STATE* m);
DLLEXPORT void waitForKeyPress();

#endif