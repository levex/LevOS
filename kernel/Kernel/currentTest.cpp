#include "currentTest.h"
#include "DebugDisplay.h"

void taskone()
{
	while(1) {
		DebugPrintf("1");
	}
}
void tasktwo()
{
	while(1) {
		DebugPrintf("2");
	}
}