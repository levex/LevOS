#ifndef _STRING_H
#define _STRING_H

typedef unsigned size_t;

extern char *strcpy(char *s1, const char *s2);
extern size_t strlen ( const char* str );
extern int strcmp (const char* str1, const char* str2);
extern bool strlcmp(char* str1, char* str2, int len);
extern int strncpy( char *dest, char *src, int len );

/*extern void* memcpy(void *dest, const void *src, size_t count);
extern void *memset(void *dest, char val, size_t count);
extern unsigned short* memsetw(unsigned short *dest, unsigned short val, size_t count);*/

extern char* strchr (char * str, int character );
extern void strspr(char* str, char* buf, int sep, short which);

extern void strsplit(char* s1, char delim, int &count);

#endif

