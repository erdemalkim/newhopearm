#ifndef STMWRAP_H
#define STMWRAP_H
#include "poly.h"



void clock_setup(void);
void gpio_setup(void);
void usart_setup(int baud);
void rng_setup(void);
void dma_transmit_setup(void);
void dma_request_setup(void);
void dma_request(void* buffer, const int datasize);
void dma_transmit(const void* buffer, const int datasize);
int dma_done(void);
void signal_host(void);
void send_USART_str(const unsigned char* in);
void send_USART_carr(const unsigned char* in);
void send_USART_bytes(const unsigned char* in, int n);
void recv_USART_bytes(unsigned char* out, int n);
void random_int(uint32_t*,int);
/*void poly_getnoise_fast(poly *r, unsigned char *seed, unsigned char nonce);*/
#endif
