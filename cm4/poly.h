#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"


typedef struct {
  uint16_t v[PARAM_N];
} poly;

void poly_uniform(poly *a, const unsigned char *seed);
void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce);
void poly_add(poly *r, const poly *a, const poly *b);
void poly_getnoise_fast(poly *r, unsigned char *seed, unsigned char nonce);
void poly_bitrev(poly *r);
void poly_ntt(poly *r);
void poly_invntt(poly *r);
void poly_pointwise(poly *r, const poly *a, const poly *b);

void poly_frombytes(poly *r, const unsigned char *a);
void poly_tobytes(unsigned char *r, const poly *p);

#endif
