#ifndef __LEV_FUTILS_H_
#define __LEV_FUTILS_H_

DLLEXPORT int getNumberOfFilesInRoot();
DLLEXPORT char* getFilesInRoot();
DLLEXPORT char _cdecl loadFileToLoc(char* filename, char* address);
DLLEXPORT char _cdecl executePE32(char* filename);
DLLEXPORT bool _cdecl dumpPE32(char* filename);

#endif