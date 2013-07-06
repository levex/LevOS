#ifndef __LEV_KYBRD_H_
#define __LEV_KYBRD_H_
#define DLLIMPORT extern "C" __declspec(dllimport)
typedef struct {
	int mx;
	int my;
} MOUSE_STATE;

DLLIMPORT char _cdecl getInputChar();
DLLIMPORT void _cdecl fillMouseState(MOUSE_STATE* m);
DLLIMPORT void waitForKeyPress();

#endif