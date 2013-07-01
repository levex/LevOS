#ifndef __GUFL_H_
#define __GUFL_H_


typedef struct {
	void* load;
	void* verify;
	bool valid;
} LOADER;

extern unsigned int GUFL_registerLoader(LOADER* l);
extern LOADER* GUFL_getLoader(int i);


#endif