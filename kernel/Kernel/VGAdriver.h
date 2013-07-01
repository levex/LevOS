#ifndef __VGADRIVER_H_
#define __VGADRIVER_H_

extern void write_registers(unsigned char *regs);
extern void VGA_clear_screen();
extern void VGA_init(int width, int height, int bpp);
extern void VGA_put_pixel(int x, int y, char color);
extern void VGA_put_image(int x, int y, char* filename);
extern void VGA_put_string(int x, int y,char* str);
extern void VGA_put_char(int x, int y,char c);
extern void VGA_deinit();
extern void VGA_setfont(char* f);
extern void VGA_put_line(int x0, int y0, int x1, int y1, char color);
extern void VGA_put_rectangle(int sx, int sy, int ex, int ey, char fill);

typedef unsigned char* (_cdecl *PIXEL_WRITER)(int, int, char);

typedef struct {
	char id;
	int width;
	int height;
	char bpp;
	PIXEL_WRITER putpixel;
	char* address;
} VIDEO_MODE;

typedef struct {
	char R;
	char G;
	char B;
}palette_entry;

#endif