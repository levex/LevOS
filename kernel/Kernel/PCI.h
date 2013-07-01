#ifndef __PCI_H_
#define __PCI_H_

extern void PCI_test();

extern unsigned int pciConfigReadWord (unsigned short bus, unsigned short slot, unsigned short func, unsigned short offset);
extern unsigned short pciCheckVendor(unsigned short bus, unsigned short slot);

#endif