#include "hw_mouse.h"
#include "HComm.h"
#include "DebugDisplay.h"

static unsigned char mice_cycle=0;
static signed char mice_byte[3];
static signed char mice_x=0;
static signed char mice_y=0;

static MOUSE_STATE mState;

MOUSE_STATE getMouseState()
{
	return mState;
}
void setMouseState(MOUSE_STATE m)
{
	mState.mx = m.mx;
	mState.my = m.my;
}
void fillMouseState(MOUSE_STATE* m)
{
	m->mx = mState.mx;
	m->my = mState.my;
	return;
}


//Mouse functions
void mice_handler()
{
	_asm add esp, 12
	_asm pushad
	_asm cli
	outport(0xE9, 'M');
	switch(mice_cycle)
	{
		case 0:
			mice_byte[0]=inport(0x60);
			mice_cycle++;
			break;
		case 1:
			mice_byte[1]=inport(0x60);
			mice_cycle++;
			break;
		case 2:
			mice_byte[2]=inport(0x60);
			mice_x=mice_byte[1];
			mice_y=mice_byte[2];
			mice_cycle=0;
			break;
	}
	mState.mx = mice_x;
	mState.my = mice_y;
	// tell hal we are done
	interruptdone(12);

	// return from interrupt handler
	_asm sti
	_asm popad
	_asm iretd
}

inline void mice_wait(unsigned char a_type) //unsigned char
{
	unsigned int _time_out=100000;
	if(a_type==0)
	{
		while(_time_out--) //Data
		{
			if((inport(0x64) & 1)==1)
			{
				return;
			}
		}
		return;
	}
	else
	{
		while(_time_out--) //Signal
		{
			if((inport(0x64) & 2)==0)
			{
				return;
			}
		}
		return;
	}
}

inline void mice_write(unsigned char a_write) //unsigned char
{
	//Wait to be able to send a command
	mice_wait(1);
	//Tell the mouse we are sending a command
	outport(0x64, 0xD4);
	//Wait for the final part
	mice_wait(1);
	//Finally write
	outport(0x60, a_write);
}

unsigned char mice_read()
{
	//Get's response from mouse
	mice_wait(0); 
	return inport(0x60);
}

bool mice_install()
{
	return false;
	unsigned char _status;  //unsigned char

	//Enable the auxiliary mouse device
	mice_wait(1);
	outport(0x64, 0xA8);
  
	//Enable the interrupts
	mice_wait(1);
	outport(0x64, 0x20);
	mice_wait(0);
	_status=(inport(0x60) | 2);
	mice_wait(1);
	outport(0x64, 0x60);
	mice_wait(1);
	outport(0x60, _status);
  
	//Tell the mouse to use default settings
	mice_write(0xF6);
	mice_read();  //Acknowledge
  
	//Enable the mouse
	mice_write(0xF4);
	mice_read();  //Acknowledge

	//Setup the mouse handler
	setint(44, (I86_IRQ_HANDLER)mice_handler);

	return true;
}