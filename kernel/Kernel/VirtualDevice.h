#ifndef __VIRTUAL_DEVICE_H_
#define __VIRTUAL_DEVICE_H_

typedef unsigned char* (_cdecl *FUNCTION1)(int);
typedef void (_cdecl *FUNCTION0)(void);

typedef struct __DATA_DEVICE {
	char* name;
	int uniqueID;
	FUNCTION1 read_sector;
	FUNCTION0 reset;
	FUNCTION1 init;
	FUNCTION0 deinit;
	FUNCTION1 set_drive;
} DATADEVICE;

extern bool vd_populate();
extern DATADEVICE vd_getCurrentDataDevice();
extern void vd_setCurrentDataDevice(DATADEVICE d);
extern DATADEVICE vd_getDataDeviceById(int id);

#endif