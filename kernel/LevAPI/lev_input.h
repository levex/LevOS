#ifndef __LEV_KYBRD_H_
#define __LEV_KYBRD_H_

typedef struct {
	int mx;
	int my;
} MOUSE_STATE;

extern char _cdecl getInputChar();
extern void _cdecl fillMouseState(MOUSE_STATE* m);

#endif