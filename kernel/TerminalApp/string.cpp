
//****************************************************************************
//**
//**    [string.cpp]
//**    - [Standard C string routine implimentation]
//**
//****************************************************************************
//============================================================================
//    IMPLEMENTATION HEADERS
//============================================================================
#include "string.h"
//============================================================================
//    IMPLEMENTATION PRIVATE DEFINITIONS / ENUMERATIONS / SIMPLE TYPEDEFS
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE CLASS PROTOTYPES / EXTERNAL CLASS REFERENCES
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE STRUCTURES / UTILITY CLASSES
//============================================================================
//============================================================================
//    IMPLEMENTATION REQUIRED EXTERNAL REFERENCES (AVOID)
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE DATA
//============================================================================
//============================================================================
//    INTERFACE DATA
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE FUNCTION PROTOTYPES
//============================================================================
//============================================================================
//    IMPLEMENTATION PRIVATE FUNCTIONS
//============================================================================
//============================================================================
//    INTERFACE FUNCTIONS
//============================================================================

// warning C4706: assignment within conditional expression
#pragma warning (disable:4706)

// compare two strings
int strcmp (const char* str1, const char* str2) {

	int res=0;
	while (!(res = *(unsigned char*)str1 - *(unsigned char*)str2) && *str2) {
		//print(".");
		//printchar(*(char*)str1);
		//printchar(*(char*)str2);
		++str1, ++str2;
	}

	if (res < 0)
		res = -1;
	if (res > 0)
		res = 1;

	return res;
}
bool strlcmp(char* str1, char* str2, int len)
{
	while(*str1++ == *str2++)
	{
		len --;
	}
	return len<=0;
}

void strsplit(char* s1, char delim, int &count)
{
	int i = 0;
	int j = 0;
	while(s1[j] != '\0') {
		while(s1[i] != delim) i++;
		s1[i] = '\0';
		count ++;
	}
}

// copies string s2 to s1
char *strcpy(char *s1, const char *s2)
{
    char *s1_p = s1;
    while (*s1++ = *s2++);
    return s1_p;
}

// returns length of string
size_t strlen ( const char* str ) {

	size_t	len=0;
	while (str[len++]);
	return len;
}

int strncpy( char *dest, char *src, int len )
{
	char *d, *s;
	int val = 0;

	d = dest;
	s = src;

	while ( *s != '\0' && len != 0 )
	{
		*d++ = *s++;
		len--;
		val++;
	}
	*d++ = '\0';
	
	return val;
}

/*// copies count bytes from src to dest
void *memcpy(void *dest, const void *src, size_t count)
{
    const char *sp = (const char *)src;
    char *dp = (char *)dest;
    for(; count != 0; count--) *dp++ = *sp++;
    return dest;
}

// sets count bytes of dest to val
void *memset(void *dest, char val, size_t count)
{
    unsigned char *temp = (unsigned char *)dest;
	for( ; count != 0; count--, temp[count] = val);
	return dest;
}*/


// locates first occurance of character in string
char* strchr (char * str, int character ) {

	do {
		if ( *str == character )
			return (char*)str;
	}
	while (*str++);

	return 0;
}

//puts the WHICHth separation of str by sep
void strspr(char* str, char* buff, int sep, short which)
{
	short counter = 0;
	char* backup = str;
	bool found = false;
	do {
		if ( *str == sep )
		{
			counter++; continue;
		}
		if(counter == which)
			found=true;
	}
	while (*str++);

	if(!found) return;
	*backup += counter;
	buff = backup;
}

//============================================================================
//    INTERFACE CLASS BODIES
//============================================================================
//****************************************************************************
//**
//**    END[String.cpp]
//**
//****************************************************************************
