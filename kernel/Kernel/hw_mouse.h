#ifndef __HW_MOUSE_H_
#define __HW_MOUSE_H_

typedef struct {
	int mx;
	int my;
} MOUSE_STATE;

extern bool mice_install();
extern MOUSE_STATE getMouseState();
extern void setMouseState(MOUSE_STATE m);
extern void fillMouseState(MOUSE_STATE* m);

#endif