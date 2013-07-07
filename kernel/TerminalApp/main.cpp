#define DLLIMPORT extern "C" __declspec(dllimport)

#include "..\dllTest\LevAPI\lev_text.h"
#include "..\dllTest\LevAPI\lev_time.h"
#include "..\dllTest\LevAPI\lev_input.h"
#include "..\dllTest\LevAPI\lev_futils.h"
#include "Command.h"
#include "string.h"

#include "..\Kernel\error.h"


char buf[32];
char num = 0;
char c = 0;
bool didCls = false;

COMMAND cmdlist[32] = {}; 
char currentCmd = 0;

static RTC_DATA rtc_data;

void handle_cmd(char* text, COMMAND_HANDLER f);
void cmd_help(char* b);
void cmd_test(char* b);
void cmd_about(char* b);
void cmd_start(char* b);
void cmd_cls(char* b);
void cmd_echo(char* b);
void cmd_time(char* b);
void cmd_dir(char* b);
void cmd_dobios(char* b);
void cmd_dump(char* b);
void cmd_pci(char* b);
void cmd_reboot(char* b);
void cmd_acpi(char* b);


void createCommand(char* text, char* helptext, COMMAND_HANDLER f)
{
	cmdlist[currentCmd].func = f;
	cmdlist[currentCmd].text = text;
	cmdlist[currentCmd].helptext = helptext;
	currentCmd++;
}

void main(int baseaddr)
{
	print("Terminal is executing..");
	//rtc_data = (RTC_DATA*)(baseaddr+0x8000);
	//fillRTC(rtc_data);
	clearScreen();

	createCommand("help", "\nSyntax: help <command>\nOpens up a help text!\nIf <command> is provided, provides extra information about the command.", cmd_help);
	createCommand("readtxt", "\nSyntax: readtxt <filename>\nReads a .txt file from the disk", cmd_test);
	createCommand("about", "\nOpens up an about text!", cmd_about);
	createCommand("start", "\nSyntax: start <filename>\nStarts a PE32 application of filename <filename>.", cmd_start);
	createCommand("cls", "\nClears the screen (0x17)", cmd_cls);
	createCommand("echo", "\nSyntax: echo <string>\nEchoes the arguments.", cmd_echo);
	createCommand("time", "\nShows time!", cmd_time);
	createCommand("dir", "\nLists files in root directory", cmd_dir);
	createCommand("bios", "\nJumps back to BIOS", cmd_dobios);
	createCommand("dump", "\nDumps a PE32 application or DLL", cmd_dump);
	createCommand("pci", "\nTests PCI", cmd_pci);
	createCommand("reboot", "\nReboots the PC", cmd_reboot);
	createCommand("acpi", "\nShows ACPI info", cmd_acpi);

	//moveCursorRelative(0, -1);
	print("Welcome to LevOS 2.0\nThis is a basic CLI, use 'help' for more information.\nHave fun!\n");
	print("\n[LevOS]~ ");
	while(true)
	{
		c = getInputChar();
		if(c == 0) continue;
		if(c == 0xD)
		{
			buf[num] = '\0';
			for(int j = 0; j < currentCmd; j++)
			{
				/*if(strcmp(buf, cmdlist[i].text) == 0) { cmdlist[i].func(buf); break;}*/
				bool match = true;
				for(int i = 0; i < strlen(buf); i++)
				{
					if(cmdlist[j].text[i] == buf[i] || buf[i] == ' ')
					{
						if(cmdlist[j].text[i] == '\0' || buf[i] == ' ')
						{
							match = true;
							break;
						}
						continue;
					} else {
						match = false;
						break;
					}
				}
				if(match) cmdlist[j].func(buf);
			}
			/*handle_cmd("help", cmd_help);
			handle_cmd("readtxt", cmd_test);
			handle_cmd("about", cmd_about);
			handle_cmd("start", cmd_start);
			handle_cmd("cls", cmd_cls);
			handle_cmd("echo", cmd_echo);*/
			num = 0;
			if(didCls) { print("[LevOS]~"); didCls = false; }
			else {
				print("\n[LevOS]~ ");
			}
			continue;
		}
		if(c == 0x08)
		{
			num --;
			moveCursorRelative(-1, 0);
			printchar(' ');
			moveCursorRelative(-1, 0);
			continue;
		}
		buf[num] = c;
		num++;
		printchar(c);
	}
}

void handle_cmd(char* text, COMMAND_HANDLER f)
{
	/*if(strlen(text) == strlen(buf)) 
	{*/
		bool match = true;
		for(int i = 0; i < strlen(buf); i++)
		{
			if(text[i] == buf[i] || buf[i] == ' ')
			{
				if(text[i] == '\0' || buf[i] == ' ')
				{
					match = true;
					break;
				}
				continue;
			} else {
				match = false;
				break;
			}
		}
		if(match) f(buf);
	//}
}

void cmd_help(char* buf)
{
	char* arg = strchr(buf, ' ');
	arg++;
	//if(strlen(arg) != 0)
	//if(*arg != '\0')
		for(int i = 0; i < currentCmd; i++)
		{
			if(strcmp(arg, cmdlist[i].text) == 0) {print(cmdlist[i].helptext);return;}
		}
	/*if(strcmp(arg, "readtxt") == 0)
	{
		print("\nreadtxt <filename>");
		print("\nRead a .txt file from the disk");
		return;
	} else if(strcmp(arg, "help") == 0)
	{
		print("\nhelp");
		print("\nOpens up a help text!");
		return;
	}
	else if(strcmp(arg, "about") == 0)
	{
		print("\nabout");
		print("\nOpens up an about text!");
		return;
	}
	else if(strcmp(arg, "start") == 0)
	{
		print("\nstart <filename>");
		print("\nLoads and parses a PE32 application");
		return;
	}
	else if(strcmp(arg, "cls") == 0)
	{
		print("\ncls");
		print("\nClears the screen. (0x17)");
		return;
	}
	else if(strcmp(arg, "echo") == 0)
	{
		print("\necho <string>");
		print("\nEchoes a string!");
		return;
	}*/
	print("\nWelcome to LevOS2.0!");
	print("\nCommands available: ");//help; readtxt; about; start; cls; echo");
	for(int i = 0; i < currentCmd; i++)
	{
		print(cmdlist[i].text);
		if(i != currentCmd - 1) {
			print("; ");
		}
	}
	//printchar('\n');
	print("\nUse help <command> to get better help on the commands");
	return;
}
void cmd_test(char* buf)
{
	char* arg = strchr(buf, ' ');
	arg++;
	if(*arg == '\0') {print("\nPlease give a filename!");return;}
	int c = loadFileToLoc(arg, (char*)0xC10000);
	if(c == ERR_FILE_NOT_FOUND){print("\nERROR: File not found!");return;}
	printchar('\n');
	print((char*)0xC10000);
	return;
}
void cmd_reboot(char* buf)
{
	_asm mov al, 0xFE
	_asm mov dx, 0x64
	_asm out dx, al
}
void cmd_about(char* buf)
{
	print("\nLevOS2.0 is a rewrite of the not-so-famous LevOS1.0,\nwhich failed when paging was about to be implemented :/");
	return;
}
void cmd_dobios(char* buf)
{
	_asm mov eax, 0x01
	_asm mov ebx, 0x01
	_asm int 0x2F
	return;
}
void cmd_pci(char* buf)
{
	_asm mov eax, 0x01
	_asm mov ebx, 0x02
	_asm int 0x2F
	return;
}
void cmd_acpi(char* buf)
{
	_asm mov eax, 0x01
	_asm mov ebx, 0x03
	_asm int 0x2F
	return;
}
void cmd_start(char* buf)
{
	char* arg = strchr(buf, ' ');
	arg++;
	char err = 0;
	if(*arg == '\0') {print("\nPlease give a software name!");return;}
	if(strcmp(arg, "KRNL32.exe") == 0){print("\nKernel can't be loaded! :)");return;}
	if(strcmp(arg, "cmd.exe") == 0){print("\nNo extra terminals yet! :(");return;}
	err=executePE32(arg);
	if(err == ERR_FILE_NOT_FOUND) print("\nERROR: File not found!");
	if(err == ERR_PE_NOT_EXEC) print("\nERROR: File is not executable!");
	if(err == ERR_PE_NOT_LEVOS) print("\nERROR: File is not a valid LevOS application!");
	if(err == ERR_PE_NOT_VALID) print("\nERROR: File is not a PE file!");
	return;
}
void cmd_dump(char* buf)
{
	char* arg = strchr(buf, ' ');
	arg++;
	if(*arg == '\0') {print("\nPlease give a software name!");return;}
	/*if(strcmp(arg, "KRNL32.exe") == 0){print("\nKernel can't be loaded! :)");return;}
	if(strcmp(arg, "cmd.exe") == 0){print("\nNo extra terminals yet! :(");return;}*/
	if(!dumpPE32(arg)) print("\nERROR: File not found!");
	return;
}
void cmd_cls(char* buf)
{
	didCls = true;
	clearScreen();
	return;
}
void cmd_dir(char* buf)
{
	print("Fails!");
	return;
	printchar('\n');
	char* files = getFilesInRoot();
	char num = getNumberOfFilesInRoot();
	char name[11];
	for(int i = 0; i < num; i++)
	{
			for(int j = 0; j < 11; j++)
			{
				printchar(*(files + j + i *11));
			}
			if(i != num-1)printchar('\n');
	}
	return;
}
void cmd_time(char* buf)
{
	fillRTC((unsigned int)&rtc_data);
	printchar('\n');
	print("20");
	printHexa((&rtc_data)->Year);
	print(". ");
	printHexa(rtc_data.Month);
	print(". ");
	printHexa(rtc_data.DayOfMonth);
	print(". ");
	printHexa(rtc_data.Hour);
	printchar(':');
	printHexa(rtc_data.Minute);
	printchar(':');
	printHexa(rtc_data.Second);
	return;
}
void cmd_echo(char* b)
{
	char* arg = strchr(b, ' ');
	arg++;
	if(*arg == '\0') return;
	printchar('\n');
	print(arg);
}