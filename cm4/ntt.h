#ifndef NTT_H
#define NTT_H

#include "inttypes.h"

extern uint16_t omegas_montgomery[];
extern uint16_t omegas_inv_montgomery[];
extern uint16_t psis_bitrev_montgomery[];
extern uint16_t psis_inv_montgomery[];
void bitrev_vector(uint16_t* poly);
void mul_coefficients(uint16_t* poly, uint16_t* factors);
void mul_coeff(uint16_t* poly, uint16_t* factors);
void mul_coeff_with_psis(uint16_t* poly);
void ntt(uint16_t* poly, const uint16_t* omegas);
uint16_t barrett_reduce(uint16_t a);
#endif
