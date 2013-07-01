#include "RTC.h"

int rtc_getYear()
{
	outport(0x70, 0x09);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

int rtc_getMonth()
{
	outport(0x70, 0x08);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

int rtc_getDayOfMonth()
{
	outport(0x70, 0x07);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

// 1=sunday
int rtc_getWeekday()
{
	outport(0x70, 0x06);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

int rtc_getHour()
{
	outport(0x70, 0x04);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

int rtc_getMinute()
{
	outport(0x70, 0x02);
	//sleep(1);
	int year = inport(0x71);
	return year;
}

int rtc_getSecond()
{
	outport(0x70, 0x00);
	//sleep(1);
	int year = inport(0x71);
	return year;
}