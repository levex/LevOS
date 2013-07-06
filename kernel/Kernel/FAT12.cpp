#include "DebugDisplay.h"
#include "FAT12.h"
#include "pMemory.h"
#include <string.h>
#include "VirtualDevice.h"
#include "BiosBootBlock.h"
//#include <ctype.h>

//bytes per sector
#define SECTOR_SIZE 512

//FAT FileSystem
FILESYSTEM _FSysFat;

//Mount info
MOUNT_INFO _MountInfo;

//File Allocation Table (FAT)
uint8_t FAT [SECTOR_SIZE*2];

/**
*	Helper function. Converts filename to DOS 8.3 file format
*/
void ToDosFileName (const char* filename,
            char* fname,
            unsigned int FNameLength) {

	unsigned int  i=0;

	if (FNameLength > 11)
		return;

	if (!fname || !filename)
		return;

	//set all characters in output name to spaces
	memset (fname, ' ', FNameLength);

	//8.3 filename
	for (i=0; i < strlen(filename)-1 && i < FNameLength; i++) {

		if (filename[i] == '.' || i==8 )
			break;

		//capitalize character and copy it over (we dont handle LFN format)
		fname[i] = toupper (filename[i] );
	}

	//add extension if needed
	if (filename[i]=='.') {

		//note: cant just copy over-extension might not be 3 chars
		for (int k=0; k<3; k++) {

			++i;
			if ( filename[i] )
				fname[8+k] = filename[i];
		}
	}

	//extension must be uppercase (we dont handle LFNs)
	for (i = 0; i < 3; i++)
		fname[8+i] = toupper (fname[8+i]);
}

void fsysFatGetFilesInRoot(char* ret)
{
	char* _ret = ret;
	char j = 0;
	unsigned char* buf;
	buf = (unsigned char*) vd_getCurrentDataDevice().read_sector(_MountInfo.rootOffset);
	while(*buf != 0)
	{
		DIRECTORY* dir = (DIRECTORY*)(buf);
		memcpy((char*)dir->Filename, ret, 11);
		buf += sizeof(dir);
		j++;
	}

	return;
}

char fsysFatGetNumberOfFilesInRoot()
{
	char* ret;
	char j = 0;
	unsigned char* buf;
	buf = (unsigned char*) vd_getCurrentDataDevice().read_sector(_MountInfo.rootOffset);
	while(*buf != 0)
	{
		j++;
		buf += 0x20;
	}

	return ++j;
}

/**
*	Locates file or directory in root directory
*/
FILE fsysFatDirectory (const char* DirectoryName) {

	FILE file;
	unsigned char* buf;
	PDIRECTORY directory;

	//get 8.3 directory name
	char DosFileName[11];
	ToDosFileName (DirectoryName, DosFileName, 11);
	DosFileName[11]=0;

	//14 sectors per directory
	/*
		The root directory contains, at most, 224 DIRECTORY entries.
		A DIRECTORY entry is 32 bytes, 224*32=7168 bytes, 7168 bytes / 512 bytes (512 bytes in a cluster) = 14. 
		This means the root directory consists of 14 clusters.
	*/
	for (int sector=0; sector<14; sector++) {

		//read in sector of root directory
		buf = (unsigned char*) vd_getCurrentDataDevice().read_sector(_MountInfo.rootOffset + sector );

		//get directory info
		directory = (PDIRECTORY) buf;

		//16 entries per sector
		/*
			512 (one sector) = 32*16
		*/
		for (int i=0; i<16; i++) {

			//get current filename
			char name[11];
			memcpyTF (name, (char*)(directory->Filename), 11);
			name[11]=0;

			//find a match?
			if (strcmp (DosFileName, name) == 0) {

				//found it, set up file info
				strcpy (file.name, DirectoryName);
				file.id             = 0;
				file.currentCluster = directory->FirstCluster;
				file.fileLength     = directory->FileSize;
				file.eof            = 0;
				file.fileLength     = directory->FileSize;

				//set file type
				if (directory->Attrib == 0x10)
					file.flags = FS_DIRECTORY;
				else
					file.flags = FS_FILE;

				//return file
				return file;
			}

			//go to next directory
			directory++;
		}
	}

	//unable to find file
	file.flags = FS_INVALID;
	return file;
}

void fsysFatWrite(PFILE file, unsigned char* Buffer, unsigned int Length)
{
	if(!file) return;
	if(Length == 0) return;
	if(Buffer == 0) return;
	/*
	Writing a file:
		Find an empty cluster
		Create a root directory entry
		Create a FAT entry for the cluster
		Repeat until filesize is accomplished.
	*/
	int StartSectorOfDataOnDisk = _MountInfo.rootOffset + _MountInfo.rootSize; // skip reserved, bpb, rootdir

	/* STEP: find free spot in root directory */
	// The root directory consists of 14 sectors AT MOST
	unsigned char* sector = (unsigned char*)(vd_getCurrentDataDevice().read_sector(_MountInfo.rootOffset));
	for(int i = 0; i < 14; i++) // do for each sector
	{
		sector = (unsigned char*)(vd_getCurrentDataDevice().read_sector(_MountInfo.rootOffset + i));
		DIRECTORY* entry = (DIRECTORY*)sector;
		
	}
}

/**
*	Reads from a file
*/
void fsysFatRead(PFILE file, unsigned char* Buffer, unsigned int Length) {

	if (file) {

		//starting physical sector
		unsigned int physSector = 32 + (file->currentCluster - 1);

		//read in sector
		unsigned char* sector = (unsigned char*) vd_getCurrentDataDevice().read_sector ( physSector );

		//copy block of memory
		memcpyTF ((char*)Buffer, (char*)sector, 512);

		//locate FAT sector
		unsigned int FAT_Offset = file->currentCluster + (file->currentCluster / 2); //multiply by 1.5
		unsigned int FAT_Sector = 1 + (FAT_Offset / SECTOR_SIZE);
		unsigned int entryOffset = FAT_Offset % SECTOR_SIZE;

		//read 1st FAT sector
		sector = (unsigned char*) vd_getCurrentDataDevice().read_sector ( FAT_Sector );
		memcpyTF ((char*)FAT, (char*)sector, 512);

		//read 2nd FAT sector
		sector = (unsigned char*) vd_getCurrentDataDevice().read_sector ( FAT_Sector + 1 );
		memcpyTF ((char*)(FAT + SECTOR_SIZE), (char*)sector, 512);

		//read entry for next cluster
		uint16_t nextCluster = *( uint16_t*) &FAT [entryOffset];

		//test if entry is odd or even
		if( file->currentCluster & 0x0001 )
			nextCluster >>= 4;      //grab high 12 bits
		else
			nextCluster &= 0x0FFF;   //grab low 12 bits

		//test for end of file
		if ( nextCluster >= 0xff8) {

			file->eof = 1;
			return;
		}

		//test for file corruption
		if ( nextCluster == 0 ) {

			file->eof = 1;
			return;
		}

		//set next cluster
		file->currentCluster = nextCluster;
	}
}

/**
*	Closes file
*/
void fsysFatClose (PFILE file) {

	if (file)
		file->flags = FS_INVALID;
}

/**
*	Locates a file or folder in subdirectory
*/
FILE fsysFatOpenSubDir (FILE kFile,
						const char* filename) {

	FILE file;

	//get 8.3 directory name
	char DosFileName[11];
	ToDosFileName (filename, DosFileName, 11);
	DosFileName[11]=0;

	//read directory
	while (! kFile.eof ) {

		//read directory
		unsigned char buf[512];
		fsysFatRead (&file, buf, 512);

		//set directort
		PDIRECTORY pkDir = (PDIRECTORY) buf;

		//16 entries in buffer
		for (unsigned int i = 0; i < 16; i++) {

			//get current filename
			char name[11];
			memcpyTF (name, (char*)(pkDir->Filename), 11);
			name[11]=0;

			//match?
			if (strcmp (name, DosFileName) == 0) {

				//found it, set up file info
				strcpy (file.name, filename);
				file.id             = 0;
				file.currentCluster = pkDir->FirstCluster;
				file.fileLength     = pkDir->FileSize;
				file.eof            = 0;
				file.fileLength     = pkDir->FileSize;

				//set file type
				if (pkDir->Attrib == 0x10)
					file.flags = FS_DIRECTORY;
				else
					file.flags = FS_FILE;

				//return file
				return file;
			}

			//go to next entry
			pkDir++;
		}
	}

	//unable to find file
	file.flags = FS_INVALID;
	return file;
}

/**
*	Opens a file
*/
FILE fsysFatOpen (const char* FileName) {

	FILE curDirectory;
	char* p = 0;
	bool rootDir=true;
	char* path = (char*) FileName;

	//any '\'s in path?
	p = strchr (path, '\\');
	if (!p) {

		//nope, must be in root directory, search it
		curDirectory = fsysFatDirectory (path);

		//found file?
		if (curDirectory.flags == FS_FILE)
			return curDirectory;
		//unable to find
		FILE ret;
		ret.flags = FS_INVALID;
		return ret;
	}

	//go to next character after first '\'
	p++;

	while ( p ) {

		//get pathname
		char pathname[16];
		int i=0;
		for (i=0; i<16; i++) {

			//if another '\' or end of line is reached, we are done
			if (p[i]=='\\' || p[i]=='\0')
				break;

			//copy character
			pathname[i]=p[i];
		}
		pathname[i]=0; //null terminate

		//open subdirectory or file
		if (rootDir) {

			//search root directory - open pathname
			curDirectory = fsysFatDirectory (pathname);
			rootDir=false;
		}
		else {

			//search a subdirectory instead for pathname
			curDirectory = fsysFatOpenSubDir (curDirectory, pathname);
		}

		//found directory or file?
		if (curDirectory.flags == FS_INVALID)
			break;

		//found file?
		if (curDirectory.flags == FS_FILE)
			return curDirectory;

		//find next '\'
		p=strchr (p+1, '\\');
		if (p)
			p++;
	}

	//unable to find
	FILE ret;
	ret.flags = FS_INVALID;
	return ret;
}

/**
*	Mounts the filesystem
*/
void fsysFatMount () {

	//Boot sector info
	PBOOTSECTOR bootsector;

	//read boot sector
	bootsector = (PBOOTSECTOR) vd_getCurrentDataDevice().read_sector (0);

	//store mount info
	_MountInfo.numSectors     = bootsector->Bpb.NumSectors;
	_MountInfo.fatOffset      = 1;
	_MountInfo.fatSize        = bootsector->Bpb.SectorsPerFat;
	_MountInfo.fatEntrySize   = 8;
	_MountInfo.numRootEntries = bootsector->Bpb.NumDirEntries;
	_MountInfo.rootOffset     = (bootsector->Bpb.NumberOfFats * bootsector->Bpb.SectorsPerFat) + 1;
	_MountInfo.rootSize       = ( bootsector->Bpb.NumDirEntries * 32 ) / bootsector->Bpb.BytesPerSector;
}

/**
*	Initialize filesystem
*/
void fsysFatInitialize (DATADEVICE datadev) {

	//initialize filesystem struct
	strcpy (_FSysFat.Name, "FAT12");
	_FSysFat.Directory = fsysFatDirectory;
	_FSysFat.Mount     = fsysFatMount;
	_FSysFat.Open      = fsysFatOpen;
	_FSysFat.Read      = fsysFatRead;
	_FSysFat.Close     = fsysFatClose;

	//register ourself to volume manager
	volRegisterFileSystem ( &_FSysFat, datadev.uniqueID );

	//mounr filesystem
	fsysFatMount ();
}
