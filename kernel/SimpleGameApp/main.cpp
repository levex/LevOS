#include "..\LevAPI\lev_time.h"
#include "..\LevAPI\lev_text.h"
#include "..\LevAPI\lev_input.h"

int random_seed=0;
RTC_DATA rtc_data;

//lineáris kongruencia alapján
// X_n = (aX_(n-1) + c)   mod m
int random(int seed, int max)
{
	random_seed = random_seed+seed * 1103515245 + 12345;
	return (unsigned int)(random_seed / 65536) % (max+1); 
}

int parseInt(char* string)
{
	int r = 0;
	while(*string != '\0') {
		r *= 10;
		r += (*string++ - 48);
	}
	return r;
}

void main()
{
	print("\nGuess-the-Number v1.0 by Levex!\nPress a key to start!");
	getInputChar();
	fillRTC((unsigned int)&rtc_data);
	int num = random(rtc_data.Second + rtc_data.Minute + rtc_data.DayOfMonth + rtc_data.Hour, 100);
	int tries = 0;
	//printNumber(parseInt("1234"));
	//printNumber(num);
	print("\nI have thought of a number!\nType in your number and I shall reply whether it is bigger or smaller!\n");
getinput:
	char buf[64];
	for(int i = 0;; i++)
	{
		char c = getInputChar();
		if(c == 0xD) {
			if(i == 0) {printchar('\n'); i--; continue;}
			buf[i]='\0';
			int guess = parseInt(buf);
			if(guess == num)
			{
				print("\nCorrect! Thanks for playing! :) Tries: ");
				printNumber(tries);
				return;
			} else if(guess < num)
			{
				print("\nYour number is too low!");
				tries++;
			} else if(guess > num)
			{
				print("\nYour number is too much!");
				tries++;
			}
			printchar('\n');
			goto getinput;
		}
		if(c == '\0') continue;
		if(c < 48 || c > 57) continue; // skip non numbers
		printchar(c);
		buf[i] = c;
	}
	return;
}