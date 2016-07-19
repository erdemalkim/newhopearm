#include <stdint.h>
#include <assert.h> //XXX: only for debugging
#include "fips202.h"
#include <string.h>

static void keccak_absorb(uint64_t *s,
                          unsigned int r,
                          const unsigned char *m, unsigned long long int mlen,
                          unsigned char p)
{
  unsigned long long i;
  unsigned char t[200];

  for (i = 0; i < 25; ++i)
    s[i] = 0;
  
  for (i = 0; i < r; ++i)
    t[i] = 0;
  for (i = 0; i < mlen; ++i)
    t[i] = m[i];
  t[i] = p;
  t[r - 1] |= 128;
  KeccakF1600_StateXORBytes(s,t, 0, r);
}


static void keccak_squeezeblocks(unsigned char *h, unsigned long long int nblocks,
                                 uint64_t *s, 
                                 unsigned int r)
{
  while(nblocks > 0) 
  {
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h, 0,r );
    h += r;
    nblocks--;
  }
}



void shake128_absorb(uint64_t *s, const unsigned char *input, unsigned int inputByteLen)
{
  keccak_absorb(s, SHAKE128_RATE, input, inputByteLen, 0x1F);
}


void shake128_squeezeblocks(unsigned char *output, unsigned long long nblocks, uint64_t *s)
{
  keccak_squeezeblocks(output, nblocks, s, SHAKE128_RATE);
}

void shake128(unsigned char *output, unsigned int outputByteLen, const unsigned char *input, unsigned int inputByteLen)
{
  uint64_t s[25];
  assert(!(outputByteLen%SHAKE128_RATE));
  shake128_absorb(s, input, inputByteLen);
  shake128_squeezeblocks(output, outputByteLen/SHAKE128_RATE, s);
}


void sha3256(unsigned char *output, const unsigned char *input, unsigned int inputByteLen)
{
  uint64_t s[64];
  unsigned char t[SHA3_256_RATE];
  int i;

  keccak_absorb(s, SHA3_256_RATE, input, inputByteLen, 0x06);
  keccak_squeezeblocks(t, 1, s, SHA3_256_RATE);
  for(i=0;i<32;i++)
    output[i] = t[i];
}
