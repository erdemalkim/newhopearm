/* Based on the public domain implementation in
 * crypto_hash/keccakc512/simple/ from http://bench.cr.yp.to/supercop.html
 * by Ronny Van Keer 
 * and the public domain "TweetFips202" implementation
 * from https://twitter.com/tweetfips202
 * by Gilles Van Assche, Daniel J. Bernstein, and Peter Schwabe */

#include <stdint.h>
#include "fips202.h"


static void keccak_squeezefourblocks_asm(unsigned char *h,
                                 uint64_t *s, 
                                 unsigned int r)
{
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h, 0,r );
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h+r, 0,r );
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h+(2*r), 0,r );
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h+(3*r), 0,r );


}


static void keccak_squeezeblock_asm(unsigned char *h,
                                 uint64_t *s, 
                                 unsigned int r)
{
    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, h, 0,r );
}



static void keccak_absorb_asm(uint64_t *s,
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
  KeccakF1600_StateXORBytes(s,t,0,r);
}


void shake128_absorb_asm(uint64_t *s, const unsigned char *input, unsigned int inputByteLen)
{
    
    keccak_absorb_asm(s, SHAKE128_RATE, input, inputByteLen, 0x1F);
}



void shake128_squeezeblocks_asm(unsigned char *output, unsigned int nblocks, uint64_t *s)
{
    char out[16];
    if (nblocks == 4){
        keccak_squeezefourblocks_asm(output, s, SHAKE128_RATE);
    }
    else if (nblocks == 1){
        keccak_squeezeblock_asm(output, s, SHAKE128_RATE);
    }

}

	

void sha3256(unsigned char *output, const unsigned char *input, unsigned int inputByteLen)
{
  uint64_t s[25];
  unsigned char t[SHA3_256_RATE];
  int i;

    KeccakF1600_StateInitialize(s);
    keccak_absorb_asm(s, SHA3_256_RATE, input, inputByteLen, 0x06);

    KeccakF1600_StatePermute(s);
    KeccakF1600_StateExtractBytes(s, t, 0,SHA3_256_RATE );
    for(i=0;i<32;i++)
        output[i] = t[i];
}
