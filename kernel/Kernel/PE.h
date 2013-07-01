#ifndef __PE_H_
#define __PE_H_

struct PeHeader {
	int mMagic; // PE\0\0 or 0x00004550
	short mMachine;
	short mNumberOfSections;
	int mTimeDateStamp;
	int mPointerToSymbolTable;
	int mNumberOfSymbols;
	short mSizeOfOptionalHeader;
	short mCharacteristics;
};

struct PeSectionHeader { // @fix
	char sName[8]; //8
	int sVirtSize;//12
	int sVirtAddr;//16
	int sSizeOfRawData; // 20
	int sPointerToRawData;// 24
	int sPointerToRelocations; // 28
	int sPointerToLinenumbers; // 32
	short sNumberOfRelocations; // 34
	short sNumberOfLinenumbers; // 36
	int sCharacterics; // 40
};

struct PeOptionalHeader {
	short mMagic; // 0x010b - PE32, 0x020b - PE32+ (64 bit)
	char  mMajorLinkerVersion;
	char  mMinorLinkerVersion;
	int mSizeOfCode;
	int mSizeOfInitializedData;
	int mSizeOfUninitializedData;
	int mAddressOfEntryPoint;
	int mBaseOfCode;
	int mBaseOfData;
	int mImageBase;
	int mSectionAlignment;
	int mFileAlignment;
	short mMajorOperatingSystemVersion;
	short mMinorOperatingSystemVersion;
	short mMajorImageVersion;
	short mMinorImageVersion;
	short mMajorSubsystemVersion;
	short mMinorSubsystemVersion;
	int mWin32VersionValue;
	int mSizeOfImage;
	int mSizeOfHeaders;
	int mCheckSum;
	short mSubsystem;
	short mDllCharacteristics;
	int mSizeOfStackReserve;
	int mSizeOfStackCommit;
	int mSizeOfHeapReserve;
	int mSizeOfHeapCommit;
	int mLoaderFlags;
	int mNumberOfRvaAndSizes;
};


struct PeDataDirectory {
	int dVirtualAddress;
	int dSize;
};

struct PeExportDirectory {
	int eCharacteristics;
	int eTimestamp;
	short eMajorVersion;
	short eMinorVersion;
	int eName;
	int eBase;
	int eNumberOfFunctions;
	int eNumberOfNames;
	int eAddressOfFunctions;
	int eAddressOfNames;
	short eAddressOfOrdinals;
};

struct PeImportDirectory {
	int iCharacteristics;
	int iTimedateStamp;
	int iForwarderChain;
	int iName;
	int iFirstThunk;
};
struct PeImportFunction {
	short fHint;
	char fName; // NULL-TERMINATED!
};

struct PE_EXPORT_LIST {
	short numberOfExports;
	char* function;
	int address;
	short ordinal;
};

struct PeRelocationTableBase {
	int rVirtualAddress;
	int rSize;
};

struct PeRelocation {
	union {
		short rOffset:12;
		short rType:4;
	};
};

#endif