#ifndef __LEV_FUTILS_H_
#define __LEV_FUTILS_H_

extern int getNumberOfFilesInRoot();
extern char* getFilesInRoot();
extern bool _cdecl loadFileToLoc(char* filename, char* address);
extern void _cdecl executePE32(char* filename);
extern void _cdecl dumpPE32(char* filename);

#endif