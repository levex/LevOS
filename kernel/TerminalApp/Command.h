#ifndef __COMMAND_H_
#define __COMMAND_H_

typedef void (_cdecl *COMMAND_HANDLER)(char*);

typedef struct __COMMAND {
	char* text;
	char* helptext;
	COMMAND_HANDLER func;
} COMMAND;

#endif