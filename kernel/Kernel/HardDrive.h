#ifndef __HARDDRIVE_H_
#define __HARDDRIVE_H_

extern void hdd_init(int irq);
extern void hdd_set_working_drive(int drive);
extern char* hdd_read_sector(int sectorLBA);

#endif