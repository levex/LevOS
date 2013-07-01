#ifndef _STRING_H
#define _STRING_H

#include <size_t.h>

extern char *strcpy(char *s1, const char *s2);
extern size_t strlen ( const char* str );
extern int strcmp (const char* str1, const char* str2);
extern int strncpy( char *dest, char *src, int len );

#define isspace(c)      ((c) == ' ' || ((c) >= '\t' && (c) <= '\r'))
#define isascii(c)      (((c) & ~0x7f) == 0)
#define isupper(c)      ((c) >= 'A' && (c) <= 'Z')
#define islower(c)      ((c) >= 'a' && (c) <= 'z')
#define isalpha(c)      (isupper(c) || islower(c))
#define isdigit(c)      ((c) >= '0' && (c) <= '9')
#define isxdigit(c)     (isdigit(c) \
                         || ((c) >= 'A' && (c) <= 'F') \
                         || ((c) >= 'a' && (c) <= 'f'))
#define isprint(c)      ((c) >= ' ' && (c) <= '~')
#define toupper(c)      ((c) - 0x20 * (((c) >= 'a') && ((c) <= 'z')))
#define tolower(c)      ((c) + 0x20 * (((c) >= 'A') && ((c) <= 'Z')))
#define isascii(c)	((unsigned)(c) <= 0x7F)
#define toascii(c)	((unsigned)(c) & 0x7F)

/*extern void* memcpy(void *dest, const void *src, size_t count);
extern void *memset(void *dest, char val, size_t count);
extern unsigned short* memsetw(unsigned short *dest, unsigned short val, size_t count);*/

extern char* strchr (char * str, int character );
extern void strspr(char* str, char* buf, int sep, short which);

#endif

