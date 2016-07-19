#include "error_correction.h"

void helprec(poly *c, const poly *v, const unsigned char *seed, unsigned char nonce)
{
  int32_t v0[8], v1[8], v_tmp[4],v_tmp1[4], k,k1;
  unsigned char rbit,rbit1;
  unsigned char rand[32];
  unsigned char n[8];
  int i;

  for(i=0;i<7;i++)
    n[i] = 0;
  n[7] = nonce;

  crypto_stream_chacha20(rand,32,n,seed);

  asm_helprec((v->v),rand,(c->v));




}

