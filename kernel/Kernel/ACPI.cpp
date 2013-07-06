#include "ACPI.h"
#include "DebugDisplay.h"
#include "string.h"


RSDPDescriptor* rsdp = 0;

void ACPI_test()
{
	DebugPrintf("\nACPI testing...");
	rsdp = ACPI_findRSDP();
	DebugPrintf("\nRSDP @ 0x%x", rsdp);
	DebugPrintf("\nACPI version: %d.0", rsdp->Revision + 1);
	DebugPrintf("\nRSDT @ 0x%x", rsdp->RsdtAddress);
}

RSDPDescriptor* ACPI_findRSDP()
{
	//  0x000E0000 to 0x000FFFFF
	for(int i = 0xE0000; i < 0xFFFFF; i+=16)
	{
		if(strlcmp((char*)i, "RSD PTR ", 8)) // string length compare
		{
			//if(i & 0x10 == 0x10)
				return (RSDPDescriptor*)i;
		}
	}
	return 0;
}