#include "VirtualDevice.h"

#include "FloppyDrive.h"
#include "HardDrive.h"

DATADEVICE floppy;
DATADEVICE hdd;
static DATADEVICE byid[4];
static DATADEVICE _c;

bool vd_populate()
{
	floppy.init = (FUNCTION1)flpydsk_install;
	floppy.name = (char*)"FLOPPYDISKDRIVER";
	floppy.uniqueID = 0;
	floppy.read_sector = (FUNCTION1)flpydsk_read_sector;
	floppy.write_sector = flpydsk_write_sector;
	floppy.reset = (FUNCTION0) 0;
	floppy.deinit = (FUNCTION0) 0;
	floppy.set_drive = (FUNCTION1) flpydsk_set_working_drive;
	floppy.set_drive(0);
	floppy.init(38);
	byid[floppy.uniqueID] = floppy;

	hdd.init = (FUNCTION1)hdd_init;
	hdd.deinit = (FUNCTION0)0;
	hdd.name = (char*)"HARDDISKDRIVER";
	hdd.read_sector = (FUNCTION1)hdd_read_sector;
	hdd.reset = (FUNCTION0) 0;
	hdd.set_drive = (FUNCTION1) hdd_set_working_drive;
	hdd.uniqueID = 1;
	hdd.init(0);
	byid[hdd.uniqueID] = hdd;


	vd_setCurrentDataDevice(floppy);

	return true;
}

DATADEVICE vd_getDataDeviceById(int id)
{
	return byid[id];
}

DATADEVICE vd_getCurrentDataDevice()
{
	return _c;
}
void vd_setCurrentDataDevice(DATADEVICE d)
{
	_c = d;
}