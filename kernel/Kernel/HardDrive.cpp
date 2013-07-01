#include "HardDrive.h"
#include "HComm.h"
#include "pMemory.h"

static int _drive = 0;

void hdd_irq()
{

}

void hdd_init(int irq)
{
	hdd_set_working_drive(0x1F0);
}

void hdd_set_working_drive(int drive)
{
	_drive = drive;
}

char* hdd_read_sector(int sectorLBA)
{
	char* buffer = (char*)malloc(512);
	outport(_drive + 1, 0); // send null byte
	outport(_drive + 2, 1); // send sector count (1)
	outport(_drive + 3, (unsigned char)sectorLBA); // send sector number LOW
	outport(_drive + 4, (unsigned char)(sectorLBA >> 8)); // send sector number MID
	outport(_drive + 5, (unsigned char)(sectorLBA >> 16)); // send sector number HIGH
	outport(_drive + 6, 0x40); // send LBA28 addressing mode flag
	outport(_drive + 7, 0x20); // send READ SECTORS command.

	for (int i = 0; i < 256; i++)
	{
		short tmpword = inport(0x1F0);
		buffer[i * 2] = (unsigned char)tmpword;
		buffer[i * 2 + 1] = (unsigned char)(tmpword >> 8);
	}
	return buffer;
}
