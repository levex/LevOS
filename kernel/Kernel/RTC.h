#ifndef __RTC_H_
#define __RTC_H_
#include "HComm.h"

typedef struct ___RTC__STRUCT {
	int Year;
	int Month;
	int DayOfMonth;
	int WeekDay;
	int Hour;
	int Minute;
	int Second;
} RTC_DATA;

extern int rtc_getYear();
extern int rtc_getMonth();
extern int rtc_getDayOfMonth();
extern int rtc_getWeekday();
extern int rtc_getHour();
extern int rtc_getMinute();
extern int rtc_getSecond();

#endif