#ifndef POLY_H
#define POLY_H

#include <stdint.h>
#include "params.h"

#define POLY_BYTES 1792

typedef struct {
  uint16_t v[PARAM_N];
} poly;


extern void asm_ntt(uint16_t* poly, const uint16_t* omegas);
extern void asm_mulcoef(uint16_t* poly, const uint16_t* factors);


void poly_uniform(poly *a, const unsigned char *seed);
void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce);
void poly_bitrev(poly *r);
void poly_ntt(poly *r);
void poly_invntt(poly *r);
void poly_frombytes_all(unsigned char *a, poly *r);
void poly_tobytes_all(unsigned char *r, poly *p);
void poly_densify(poly *p);
void poly_amplify(poly *p);
#endif
