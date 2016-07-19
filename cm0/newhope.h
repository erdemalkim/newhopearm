#ifndef NEWHOPE_H
#define NEWHOPE_H

#include "poly.h"
#include "randombytes.h"
#include "crypto_stream_chacha20.h"
#include "error_correction.h"
#include <math.h>
#include <stdio.h>

extern void asm_rec(unsigned char *key, const poly *v, const poly *c);
extern void asm_poly_add(poly *r, poly *b);
extern void asm_poly_pointwise(poly *r, poly *a, poly *b);


void newhope_keygen(poly *send, poly *sk);
void newhope_sharedb(unsigned char *sharedkey, poly *send, poly *received);
void newhope_shareda(unsigned char *sharedkey, poly *ska,  poly *received);

#endif
