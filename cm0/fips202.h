#ifndef FIPS202_H
#define FIPS202_H

#define SHAKE128_RATE 168
#define SHA3_256_RATE 136

extern void KeccakF1600_StateInitialize(void *state);
extern void KeccakF1600_StateXORBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length);
extern void KeccakF1600_StatePermute( void *state );
extern void KeccakF1600_StateExtractBytes(void *state, const unsigned char *data, unsigned int offset, unsigned int length);

void shake128_absorb(uint64_t *s, const unsigned char *input, unsigned int inputByteLen);
void shake128_squeezeblocks(unsigned char *output, unsigned int nblocks, uint64_t *s);
void shake128(unsigned char *output, unsigned int outputByteLen, const unsigned char *input, unsigned int inputByteLen);
void sha3256(unsigned char *output, const unsigned char *input, unsigned int inputByteLen);

#endif
