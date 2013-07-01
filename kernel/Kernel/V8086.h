#ifndef __V8086_H_
#define __V8086_H_

typedef struct
{
	unsigned edi, esi, ebp, esp, ebx, edx, ecx, eax; /* PUSHA/POP */
	unsigned ds, es, fs, gs;
	unsigned which_int, err_code;
	unsigned eip, cs, eflags, user_esp, user_ss; /* INT nn/IRET */
	unsigned v_es, v_ds, v_fs, v_gs; /* V86 mode only */
} uregs;

/* segment:offset pair */
typedef int FARPTR;

/* Make a FARPTR from a segment and an offset */
#define MK_FP(seg, off)    ((FARPTR) (((int) (seg) << 16) | (short) (off)))

/* Extract the segment part of a FARPTR */
#define FP_SEG(fp)        (((FARPTR) fp) >> 16)

/* Extract the offset part of a FARPTR */
#define FP_OFF(fp)        (((FARPTR) fp) & 0xffff)

/* Convert a segment:offset pair to a linear address */
#define FP_TO_LINEAR(seg, off) ((void*) ((((short) (seg)) << 4) + ((short) (off))))

extern void v86_init(uregs* regs);

#endif