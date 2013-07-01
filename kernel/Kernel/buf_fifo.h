#ifndef __BUF_FIFO_H_
#define __BUF_FIFO_H_

typedef struct {
     char * buf;
     int head;
     int tail;
     int size;
} fifo_t;

extern void fifo_init(fifo_t * f, char * buf, int size);
extern int fifo_read(fifo_t * f, char * buf, int nbytes);
extern int fifo_write(fifo_t * f, const char * buf, int nbytes);


#endif