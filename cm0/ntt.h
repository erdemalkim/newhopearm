#ifndef NTT_H
#define NTT_H

#include "inttypes.h"

extern const uint16_t omegas_montgomery[];
extern const uint16_t omegas_inv_montgomery[];
extern const uint16_t psis_bitrev_montgomery[];
extern const uint16_t psis_inv_montgomery[];

void bitrev_vector(uint16_t* poly);

#endif
