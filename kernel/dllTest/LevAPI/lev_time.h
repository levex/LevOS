#ifndef __LEV_TIME_H_
#define __LEV_TIME_H_

typedef struct __RTC__DATA {
	int Year;
	int Month;
	int DayOfMonth;
	int WeekDay;
	int Hour;
	int Minute;
	int Second;
} RTC_DATA;

DLLIMPORT void _cdecl fillRTC(int data);

#endif