#ifndef CRYPTO_STREAM_CHACHA20
#define CRYPTO_STREAM_CHACHA20

#include "poly.h"

//extern void asm_crypto_core(unsigned char *out, unsigned char *k,unsigned char *in);
extern void asm_csc_for(unsigned char *in, const unsigned char *n);

int crypto_stream_chacha20(unsigned char *c,unsigned long long clen, const unsigned char *n, const unsigned char *k);

#endif
