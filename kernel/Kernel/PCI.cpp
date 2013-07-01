#include "PCI.h"
#include "DebugDisplay.h"
#include "HComm.h"

unsigned short getVendorID(unsigned short bus, unsigned short device, unsigned short function);
unsigned short getDeviceID(unsigned short bus, unsigned short device, unsigned short function);
unsigned short getClassId(unsigned short bus, unsigned short device, unsigned short function);
unsigned short getSubClassId(unsigned short bus, unsigned short device, unsigned short function);

void PCI_test()
{
	DebugPrintf("\nPCI testing..");
	// Maximum PCI capacity: 256 bus each having at most 32 slots and each slots having at most 8 functions
	for(int bus = 0; bus < 256; bus++)
	{
		for(int slot = 0; slot < 32; slot++)
		{
			for(int function = 0; function < 8; function++)
			{
				unsigned short vendor = getVendorID(bus, slot, function);
				if(vendor == 0xFFFF) continue;
				unsigned short device = getDeviceID(bus, slot, function);
				DebugPrintf("\nPCI: Bus: 0x%X Slot: 0x%x Function: 0x%x Vendor: 0x%X Device=0x%x", bus, slot,function, vendor, device);
				DebugPrintf("\n        ClassId=0x%x SubclassId=0x%x", getClassId(bus, slot, function), getSubClassId(bus, slot, function));
			}
		}
	}
}

unsigned int pciConfigReadWord (unsigned short bus, unsigned short slot, unsigned short func, unsigned short offset)
{
    unsigned long address;
    unsigned long lbus = (unsigned long)bus;
    unsigned long lslot = (unsigned long)slot;
    unsigned long lfunc = (unsigned long)func;
    unsigned short tmp = 0;
    address = (unsigned long)((lbus << 16) | (lslot << 11) |
              (lfunc << 8) | (offset & 0xfc) | ((int)0x80000000));
    outportW (0xCF8, address);
    tmp = (unsigned short)((inportW (0xCFC) >> ((offset & 2) * 8)) & 0xffff);
    return (tmp);
 }

 unsigned short pciCheckVendor(unsigned short bus, unsigned short slot)
 {
    unsigned short vendor,device;
	/* check if device is valid */
    if ((vendor = pciConfigReadWord(bus,slot,0,0)) != 0xFFFF) {
       device = pciConfigReadWord(bus,slot,0,2);
       /* valid device */
    } return (vendor);
 }

unsigned short getVendorID(unsigned short bus, unsigned short device, unsigned short function)
{
	int r0 = pciConfigReadWord(bus,device,function,0);
	// Register 00 => DeviceID(2b) VendorID(2b)
	return r0;
}

unsigned short getDeviceID(unsigned short bus, unsigned short device, unsigned short function)
{
	int r0 = pciConfigReadWord(bus,device,function,2);
	// Register 00 => DeviceID(2b) VendorID(2b)
	return r0;
}

unsigned short getClassId(unsigned short bus, unsigned short device, unsigned short function)
{
	int r0 = pciConfigReadWord(bus,device,function,0xA);
	return (r0 & ~0x00FF) >> 8;
}

unsigned short getSubClassId(unsigned short bus, unsigned short device, unsigned short function)
{
	int r0 = pciConfigReadWord(bus,device,function,0xA);
	return (r0 & ~0xFF00);
}
