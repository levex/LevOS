#ifndef __LEV_FUTILS_H_
#define __LEV_FUTILS_H_

DLLIMPORT int getNumberOfFilesInRoot();
DLLIMPORT char* getFilesInRoot();
DLLIMPORT bool _cdecl loadFileToLoc(char* filename, char* address);
DLLIMPORT bool _cdecl executePE32(char* filename);
DLLIMPORT bool _cdecl dumpPE32(char* filename);

#endif