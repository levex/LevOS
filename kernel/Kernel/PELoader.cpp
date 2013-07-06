#include "PELoader.h"
#include "PE.h"
#include "HComm.h"
#include "DebugDisplay.h"
#include "vMemory.h"
#include "pMemory.h"
#include "ProcessManager.h"
#include "string.h"

bool PE_checkImport(PeDataDirectory* begin);
PE_EXPORT_LIST* PE_loadDLL(char* filename, int base);
static PE_EXPORT_LIST pel[256];

bool PE_mapApp(char* filename, int base)
{
	if(getFileSize(filename) == 0) return false;
	// first step, load the application to the specified address
	base = base + 4*1024*1024 - getFileSize(filename) - 0x1000;
	if(!loadFileToLoc(filename, (void*)base)) {return false;}
	// second step, extract PE headers from it.
	int PE_HEADER_LOCATION = *(int*)(base + 0x3C);
	PE_HEADER_LOCATION += base;
	PeHeader* peheader = (PeHeader*)PE_HEADER_LOCATION;
	PeOptionalHeader* optionalheader = (PeOptionalHeader*)(PE_HEADER_LOCATION+24);
	if(!PE_verify(base)) 
	{
		DebugPrintf("\nERROR: Not a valid PE file!");
		return false;
	}
	if(optionalheader->mAddressOfEntryPoint == 0) {
		DebugPrintf("\nERROR: File is not for starting!");
		return false;
	}
	if(optionalheader->mMajorSubsystemVersion != 0x1337)
	{
		DebugPrintf("\nERROR: Not a valid LevOS executable!");
		return false;
	}
	// third step, map the sections
	int loadBase = base+0x1000+getFileSize(filename) - 4*1024*1024;
#ifdef DEBUG
	DebugPrintf("loadBase=0x%x,opt->imagebase=0x%x", base, optionalheader->mImageBase);
#endif
	//if((unsigned int)loadBase != (unsigned int)optionalheader->mImageBase)
	vm_map_virt_to_phys(optionalheader->mImageBase / 0x400000, loadBase);
	char* firstSectionHeader = (char*)(PE_HEADER_LOCATION+24+sizeof(PeOptionalHeader)+(optionalheader->mNumberOfRvaAndSizes * 8));
	for(int i = 0; i < peheader->mNumberOfSections; i++)
	{
		PeSectionHeader* sect = (PeSectionHeader*)firstSectionHeader;
		if(sect->sSizeOfRawData == 0) {
#ifdef DEBUG
			DebugPrintf("\nSection %s is null-length! (0x%x) Skipped.", sect->sName, sect->sSizeOfRawData);
#endif
			firstSectionHeader += sizeof(PeSectionHeader);
			continue;
		}
#ifdef DEBUG
		DebugPrintf("\nCopying %s section to 0x%X from 0x%x, size: 0x%X ", sect->sName, optionalheader->mImageBase + sect->sVirtAddr,base + sect->sPointerToRawData, sect->sSizeOfRawData);
#endif
		memcpy((char*)(base + sect->sPointerToRawData), (char*)(optionalheader->mImageBase + sect->sVirtAddr), sect->sSizeOfRawData);
		firstSectionHeader += sizeof(PeSectionHeader);
	}
#ifdef DEBUG	
	_asm push eax
	_asm mov eax, 0x4
	_asm int 0x2F
	_asm pop eax
#endif

	/* Check for import */
	PeDataDirectory* pdd = (PeDataDirectory*)((unsigned int)optionalheader+sizeof(PeOptionalHeader));
	if(PE_checkImport(pdd))
	{
		/* yes we need to import! */
		pdd++;
		PeImportDirectory* pid = (PeImportDirectory*)(optionalheader->mImageBase + pdd->dVirtualAddress);
		char* filename = (char*)(optionalheader->mImageBase + pid->iName);
		//DebugPrintf("\nLoading %s to 0x800000", filename);
		PE_loadDLL(filename, 0x800000);
		int numberOfExports = pel->numberOfExports;
		//DebugPrintf("\nDLL num = 0x%x", numberOfExports);
		for(int i = 0; i < numberOfExports; i++)
		{
			//DebugPrintf("\nDLL export: %s @ 0x%x", pel[i].function, pel[i].address);
		}
		//DebugPrintf("\n->This is an import directory!");
		int j = 0;
		while(pid->iCharacteristics != 0) // structure ends with 0
		{
			//DebugPrintf("\n-->Found DLL import from module %s", (char*)(optionalheader->mImageBase + pid->iName));
			if(strcmp((char*)(optionalheader->mImageBase + pid->iName), filename) == 0)
			{
				/* This is the DLL */
				int IATbase = (optionalheader->mImageBase + pid->iFirstThunk); // The base of Import Address Table
				int FTaddr = *(int*)(optionalheader->mImageBase + pid->iFirstThunk) + optionalheader->mImageBase; // Address of first thunk data
				//DebugPrintf("\n-->First thunk points to 0x%x",	FTaddr);
				PeImportFunction* pif = (PeImportFunction*)(FTaddr); // Put structure on top of it
				int k = 0;
				int fixed = 0;
				while(FTaddr != optionalheader->mImageBase) 
				{ // loop while the address doesn't equal zero
					//DebugPrintf("\nA");
					for(int i = 0; i < numberOfExports; i++) // loop thru all the exports of the current DLL
					{
						//DebugPrintf("\nB");
						if(strcmp(pel[i].function, &pif->fName) == 0) // function names equal?
						{
							/* FUNCTION MATCH */
							//DebugPrintf("\nFunction matched %s", pel[i].function);
							//DebugPrintf("\nC");
							*(int*)(IATbase + k*4) = pel[i].address; // if so, write the export address to the IAT (respective offset)
							//DebugPrintf("\nIATwrite: Ordinal=%d, ADDR=0x%x, NAME=%s, IATaddr=0x%x", pel[i].ordinal, pel[i].address, pel[i].function, IATbase + k*4);
							fixed++;
						} // exported =?= imported
						//DebugPrintf("\nD");
					} // export loop
					
					if(fixed == numberOfExports) break; // if we have fixed NumberOfExports addresses then quit
			redo:
					k++; // proceed to next import function
					FTaddr = *(int*)(IATbase + k * 4) + optionalheader->mImageBase; // address of next import function
					//if(FTaddr > optionalheader->mImageBase + optionalheader->mSizeOfImage) goto redo;
					//DebugPrintf("\nFTaddr = 0x%x, IATdata=0x%x", FTaddr, *(int*)(IATbase + k * 4));
					pif = (PeImportFunction*)(FTaddr); // put the structure on it
					//DebugPrintf("\nProceeding to next import from this DLL");
				}
			} // import loop
			//DebugPrintf("\nDLL finished.");
			j++;
			pid ++; // go to next DLL entry
			//DebugPrintf("\nChar=0x%x",pid->iCharacteristics);
		} // dll entries
		//DebugPrintf("\nIMPORTing not yet implemented.");
		//return false;
	}


	int entry = optionalheader->mImageBase + optionalheader->mAddressOfEntryPoint;
	//DebugPrintf("App start...");
	_asm push loadBase;
	_asm call entry;
	//restoreKernelStack();
	return true;
}
PE_EXPORT_LIST* PE_loadDLL(char* filename, int base)
{
	int loadBase = base;
	base = base + 4*1024*1024 - getFileSize(filename) - 0x1000;
	if(!loadFileToLoc(filename, (void*)base)) {return 0;}
	// second step, extract PE headers from it.
	int PE_HEADER_LOCATION = *(int*)(base + 0x3C);
	PE_HEADER_LOCATION += base;
	PeHeader* peheader = (PeHeader*)PE_HEADER_LOCATION;
	PeOptionalHeader* optionalheader = (PeOptionalHeader*)(PE_HEADER_LOCATION+24);
	//DebugClrScr(0x17);
	//DebugPrintf("\nDumping PeOptionalHeader...");
	//DebugPrintf("\nMagic=0x%x\nSizeOfCode=0x%x\nSizeOfData=0x%x\nAddressOfEntryPoint=0x%x\nSizeOfImage=0x%x\nNumberOfSections=0x%x", optionalheader->mMagic, optionalheader->mSizeOfCode, optionalheader->mSizeOfInitializedData, optionalheader->mAddressOfEntryPoint, optionalheader->mSizeOfImage, peheader->mNumberOfSections);
	// third step, map the sections
	//int loadBase = base+0x1000+getFileSize(filename) - 4*1024*1024;
	bool doReloc = false;
	int relocDelta = 0;
	if(optionalheader->mImageBase != loadBase)
	{
		relocDelta = loadBase - optionalheader->mImageBase;
		DebugPrintf("\nDLL needs relocation! ImageBase=0x%x loadBase=0x%x relocDelta=0x%x", optionalheader->mImageBase, loadBase, relocDelta);
		doReloc = true;
	}
#ifdef DEBUG
	DebugPrintf("loadBase=0x%x,opt->imagebase=0x%x", base, optionalheader->mImageBase);
#endif
	//if((unsigned int)loadBase != (unsigned int)optionalheader->mImageBase)
	//vm_map_virt_to_phys(optionalheader->mImageBase / 0x400000, loadBase);
	char* firstSectionHeader = (char*)(PE_HEADER_LOCATION+24+sizeof(PeOptionalHeader)+(optionalheader->mNumberOfRvaAndSizes * 8));
	for(int i = 0; i < peheader->mNumberOfSections; i++)
	{
		PeSectionHeader* sect = (PeSectionHeader*)firstSectionHeader;
		if(sect->sSizeOfRawData == 0) {
#ifdef DEBUG
			DebugPrintf("\nSection %s is null-length! (0x%x) Skipped.", sect->sName, sect->sSizeOfRawData);
#endif
			firstSectionHeader += sizeof(PeSectionHeader);
			continue;
		}
//#ifdef DEBUG
		//DebugPrintf("\nCopying %s section to 0x%X from 0x%x, size: 0x%X ", sect->sName, optionalheader->mImageBase + sect->sVirtAddr,base + sect->sPointerToRawData, sect->sSizeOfRawData);
//#endif
		memcpy((char*)(base + sect->sPointerToRawData), (char*)(loadBase + sect->sVirtAddr), sect->sSizeOfRawData);
		firstSectionHeader += sizeof(PeSectionHeader);
	}
	unsigned int currentNameAddr=0;
	char* currentName = 0;
	unsigned int currentAddress = 0;
	unsigned short currentOrdinal = 0;
	PeExportDirectory* exp = 0;
	PeImportDirectory* imp = 0;
	PeRelocationTableBase* rtb = 0;
	/* check for relocation */
	if(doReloc)
	{
		PeDataDirectory* ddir = (PeDataDirectory*)((unsigned int)optionalheader + sizeof(PeOptionalHeader));
		for(int j = 0; j < 16; j++)
		{
			if(ddir->dSize != 0 && ddir->dVirtualAddress != 0) {
					if(j == 5) {
						//break;
						// relocation table
						rtb = (PeRelocationTableBase*)(loadBase + ddir->dVirtualAddress);
						int numberOfRelocations = (rtb->rSize - sizeof(PeRelocationTableBase))/2; // number of relocations can be calculated with that formula
						short* pr = (short*)(loadBase + ddir->dVirtualAddress + sizeof(PeRelocationTableBase)); // pr is a 2byte pointer
						while(rtb->rSize != 0) { // loop until the next relocpage entry is 0
							//DebugPrintf("\n-->Page 0x%x found %d relocations, first at: 0x%x", rtb->rVirtualAddress ,numberOfRelocations, pr);
							for(int i = 0; i<numberOfRelocations; i++) // loop thru the relocations
							{
								//DebugPrintf("\n--->Reloc: Offset: 0x%x Type: 0x%x",(*pr & 0x0FFF) + rtb->rVirtualAddress, (*pr & 0xF000) >> 12); // extract offset and type
								int* offset = (int*)(rtb->rVirtualAddress + loadBase + (*pr & 0x0FFF));
								short type = (*pr & 0xF000) >> 12;
								//DebugPrintf("\nReloc: Offset: 0x%x Type: 0x%x ", offset, type, *offset);
								if(type != 0) { // if type equals 0 then it is of type OBSOLETE and that means this Reloc is only here for rounding
									int data = *offset;
									//DebugPrintf("\n->Data before: 0x%x", data);
									*offset = data + relocDelta;
									//DebugPrintf("\n->Data now: 0x%x", *offset);
								}
								pr++; // advance to next relocation
							}
							rtb = (PeRelocationTableBase*)(pr + 2); // advance to next pagereloc
						} 
						break;
					}
			}
			ddir++;
		}
	}

	/* now, lets check the export table first! */
	PeDataDirectory* ddir = (PeDataDirectory*)((unsigned int)optionalheader + sizeof(PeOptionalHeader));
	for(int j = 0; j < 16; j++)
	{
		if(ddir->dSize != 0 && ddir->dVirtualAddress != 0) {
			//DebugPrintf("\nFound datadirectory: id=0x%x, VA=0x%x, Size=0x%x", j, ddir->dVirtualAddress, ddir->dSize);
				if(j == 0) {
					// export table
					exp = (PeExportDirectory*)(loadBase + ddir->dVirtualAddress);
					//DebugPrintf("\n->This is an export directory, containing %d function(s)! Located at 0x%x",exp->eNumberOfFunctions ,exp);
					//DebugPrintf("\nnameoffset=0x%x",optionalheader->mImageBase + exp->eAddressOfNames);
					for(int k= 0; k < exp->eNumberOfFunctions; k++)
					{
						currentNameAddr = *(unsigned int*)(loadBase + exp->eAddressOfNames + k*4);
						//DebugPrintf("\ncurrentNameAddr=0x%x", currentNameAddr);
						currentName = (char*)(currentNameAddr + loadBase);
						currentOrdinal = *(short*)(loadBase + exp->eAddressOfOrdinals + k*2);
						currentAddress = *(int*)(loadBase + exp->eAddressOfFunctions + currentOrdinal*4);
						pel[k].numberOfExports = exp->eNumberOfFunctions;
						pel[k].address = currentAddress + loadBase;
						pel[k].function = currentName;
						pel[k].ordinal = currentOrdinal;
						//DebugPrintf("\n--->%s() at 0x%x, ordinal 0x%x", pel[k].function, pel[k].address, currentOrdinal);
						//currentName += strlen(currentName) + 1;
					}
				}
		}
		ddir++;
	}
	return pel;
}
bool PE_dumpApp(char* filename, int base)
{
	base = base + 4*1024*1024 - getFileSize(filename) - 0x1000;
	if(!loadFileToLoc(filename, (void*)base)) {return false;}
	if(!PE_verify(base)) 
	{
		DebugPrintf("\nERROR: Not a valid PE file!");
		return false;
	}
	// second step, extract PE headers from it.
	int PE_HEADER_LOCATION = *(int*)(base + 0x3C);
	PE_HEADER_LOCATION += base;
	PeHeader* peheader = (PeHeader*)PE_HEADER_LOCATION;
	PeOptionalHeader* optionalheader = (PeOptionalHeader*)(PE_HEADER_LOCATION+24);
	//DebugClrScr(0x17);
	DebugPrintf("\nDumping PeOptionalHeader...");
	DebugPrintf("\nMagic=0x%x\nSizeOfCode=0x%x\nSizeOfData=0x%x\nAddressOfEntryPoint=0x%x\nSizeOfImage=0x%x\nNumberOfSections=0x%x", optionalheader->mMagic, optionalheader->mSizeOfCode, optionalheader->mSizeOfInitializedData, optionalheader->mAddressOfEntryPoint, optionalheader->mSizeOfImage, peheader->mNumberOfSections);
	// third step, map the sections
	int loadBase = base+0x1000+getFileSize(filename) - 4*1024*1024;
#ifdef DEBUG
	DebugPrintf("loadBase=0x%x,opt->imagebase=0x%x", base, optionalheader->mImageBase);
#endif
	//if((unsigned int)loadBase != (unsigned int)optionalheader->mImageBase)
	//vm_map_virt_to_phys(optionalheader->mImageBase / 0x400000, loadBase);
	char* firstSectionHeader = (char*)(PE_HEADER_LOCATION+24+sizeof(PeOptionalHeader)+(optionalheader->mNumberOfRvaAndSizes * 8));
	for(int i = 0; i < peheader->mNumberOfSections; i++)
	{
		PeSectionHeader* sect = (PeSectionHeader*)firstSectionHeader;
		if(sect->sSizeOfRawData == 0) {
#ifdef DEBUG
			DebugPrintf("\nSection %s is null-length! (0x%x) Skipped.", sect->sName, sect->sSizeOfRawData);
#endif
			firstSectionHeader += sizeof(PeSectionHeader);
			continue;
		}
//#ifdef DEBUG
		DebugPrintf("\nCopying %s section to 0x%X from 0x%x, size: 0x%X ", sect->sName, optionalheader->mImageBase + sect->sVirtAddr,base + sect->sPointerToRawData, sect->sSizeOfRawData);
//#endif
		memcpy((char*)(base + sect->sPointerToRawData), (char*)(optionalheader->mImageBase + sect->sVirtAddr), sect->sSizeOfRawData);
		firstSectionHeader += sizeof(PeSectionHeader);
	}
#ifdef DEBUG	
	_asm push eax
	_asm mov eax, 0x4
	_asm int 0x2F
	_asm pop eax
#endif
	int entry = optionalheader->mImageBase + optionalheader->mAddressOfEntryPoint;
	unsigned int currentNameAddr=0;
	char* currentName = 0;
	unsigned int currentAddress = 0;
	unsigned short currentOrdinal = 0;
	PeExportDirectory* exp = 0;
	PeImportDirectory* imp = 0;
	PeRelocationTableBase* rtb  = 0;
	short* pr = 0;
	int i = 0;
	/* now, lets check the export table first! */
	PeDataDirectory* ddir = (PeDataDirectory*)((unsigned int)optionalheader + sizeof(PeOptionalHeader));
	//DebugPrintf("\nAddress of first Data Directory = 0x%x", (unsigned int)ddir);
	for(int j = 0; j < 16; j++)
	{
		if(ddir->dSize != 0 && ddir->dVirtualAddress != 0) {
			DebugPrintf("\nFound datadirectory: id=0x%x, VA=0x%x, Size=0x%x", j, ddir->dVirtualAddress, ddir->dSize);
			switch(j)
			{
				case 0:
					// export table
					exp = (PeExportDirectory*)(optionalheader->mImageBase + ddir->dVirtualAddress);
					DebugPrintf("\n->This is an export directory, containing %d function(s)! Located at 0x%x",exp->eNumberOfFunctions ,exp);
					//DebugPrintf("\nnameoffset=0x%x",optionalheader->mImageBase + exp->eAddressOfNames);
					for(int k= 0; k < exp->eNumberOfFunctions; k++)
					{
						currentNameAddr = *(unsigned int*)(optionalheader->mImageBase + exp->eAddressOfNames + k*4);
						//DebugPrintf("\ncurrentNameAddr=0x%x", currentNameAddr);
						currentName = (char*)(currentNameAddr + optionalheader->mImageBase);
						currentOrdinal = *(short*)(optionalheader->mImageBase + exp->eAddressOfOrdinals + k*2);
						currentAddress = *(int*)(optionalheader->mImageBase + exp->eAddressOfFunctions + currentOrdinal*4);
						DebugPrintf("\n--->%s() at 0x%x, ordinal 0x%x", currentName, currentAddress, currentOrdinal);
						//currentName += strlen(currentName) + 1;
					}
					break;
				case 1:
					// import table
					imp = (PeImportDirectory*)(optionalheader->mImageBase + ddir->dVirtualAddress);
					DebugPrintf("\n->This is an import directory!");
					i = 0;
					while(imp->iCharacteristics != 0) // structure ends with 0
					{
						DebugPrintf("\n-->Found DLL import from module %s", (char*)(optionalheader->mImageBase + imp->iName));
						int FTaddr = *(int*)(optionalheader->mImageBase + imp->iFirstThunk) + optionalheader->mImageBase;
						DebugPrintf("\n-->First thunk points to 0x%x",	FTaddr);
						PeImportFunction* pif = (PeImportFunction*)(FTaddr);
						int j = 0;
						while(FTaddr != optionalheader->mImageBase) {
							DebugPrintf("\n-->Hint= 0x%X, name=%s", pif->fHint, &pif->fName);
							j++;
							FTaddr = *(int*)(optionalheader->mImageBase + imp->iFirstThunk + j * 4) + optionalheader->mImageBase;
							pif = (PeImportFunction*)(FTaddr);
						}
						i++;
						imp ++; // go to next DLL entry
					}
					break;
				case 5:
					//relocation table
					rtb = (PeRelocationTableBase*)(optionalheader->mImageBase + ddir->dVirtualAddress);
					DebugPrintf("\n->This is a relocation table!");
					int numberOfRelocations = (rtb->rSize - sizeof(PeRelocationTableBase))/2; // number of relocations can be calculated with that formula
					pr = (short*)(optionalheader->mImageBase + ddir->dVirtualAddress + sizeof(PeRelocationTableBase)); // pr is a 2byte pointer
					while(rtb->rSize != 0) { // loop until the next relocpage entry is 0
						DebugPrintf("\n-->Page 0x%x found %d relocations, first at: 0x%x", rtb->rVirtualAddress ,numberOfRelocations, pr);
						for(i = 0; i<numberOfRelocations; i++) // loop thru the relocations
						{
							DebugPrintf("\n--->Reloc: Offset: 0x%x Type: 0x%x",(*pr & 0x0FFF) + rtb->rVirtualAddress, (*pr & 0xF000) >> 12); // extract offset and type
							pr++; // advance to next relocation
						}
						rtb = (PeRelocationTableBase*)(pr + 2); // advance to next pagereloc
					} 
					break;
			}
		}
		ddir++;
	}
	return true;
}

bool PE_verify(int base)
{
	//DebugPrintf("Magic=0x%X", *(short*)(base));
	if(*(short*)(base) == 0x5A4D) return true;
	return false;
}

bool PE_checkImport(PeDataDirectory* begin)
{
	for(int j = 0; j < 16; j++)
	{
		if(begin->dSize != 0 && begin->dVirtualAddress != 0) {
			if(j == 1) return true;
		}
		begin++;
	}
	return false;
}

bool PE_checkReloc(PeDataDirectory* begin)
{
	for(int j = 0; j < 16; j++)
	{
		if(begin->dSize != 0 && begin->dVirtualAddress != 0) {
			if(j == 5) return true;
		}
		begin++;
	}
	return false;
}