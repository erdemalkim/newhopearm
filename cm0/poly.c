#include "poly.h"
#include "ntt.h"
#include "randombytes.h"
#include "reduce.h"
#include "fips202.h"
#include "crypto_stream_chacha20.h"
#include "precomp.c"






void poly_amplify(poly *p)
{
  int i;
  for(i=(PARAM_N/8)-1;i>-1;i--)
  {
    p->v[(8*i)+7] =  ((p->v[(7*i)+6] & 0xff) << 6) | (p->v[(7*i)+6])>> 10;   
    p->v[(8*i)+6] =  ((p->v[7*i+6] & 0x300) << 4) | ((p->v[(7*i)+5] & 0xff) << 4) | p->v[7*i+5] >> 12;
    p->v[(8*i)+5] =  ((p->v[(7*i)+5] & 0xf00) << 2 )| ((p->v[7*i+4] & 0xff) << 2) | p->v[7*i+4] >> 14;
    p->v[(8*i)+4] =  (p->v[(7*i)+4] & 0x3f00) | (p->v[(7*i)+3] & 0xff);
    p->v[(8*i)+3] =  ((p->v[7*i+3] >>2) & 0x3fc0) | (p->v[(7*i)+2] &0xff ) >> 2;
    p->v[(8*i)+2] =  ((p->v[(7*i)+2] & 3) << 12) | ((p->v[(7*i)+2] >> 8) << 4) | (p->v[(7*i)+1] & 240) >> 4;
    p->v[(8*i)+1] =  ((p->v[(7*i)+1] & 0xf) << 10) | ((p->v[7*i+1] >> 8) << 2) |  ((p->v[(7*i)+0] >> 6) & 3);
    p->v[(8*i)+0] =  p->v[7*i+0]>>8 | (p->v[7*i+0]&63)<<8;
  }
}



void poly_tobytes_all(unsigned char *r, poly *p)
{
  int i;
  for(i=0;i<PARAM_N;i++)
  {
    r[2*i] = p->v[i] >> 8;
    r[2*i+1]   = p->v[i] & 0xff;
  }
}


void poly_frombytes_all(unsigned char *r, poly *p)
{
  int i;
  for(i=0;i<PARAM_N;i++)
  {
    p->v[i] = (r[2*i] << 8) | r[2*i+1];
  }
}


void poly_densify(poly *p)
{
  int i;
  uint16_t t0,t1,t2,t3,t4,t5,t6,t7,m;
  int16_t c;
  for(i=0;i<PARAM_N/8;i++)
  {
    t0 = barrett_reduce(p->v[8*i+0]); //Make sure that coefficients have only 14 bits
    t1 = barrett_reduce(p->v[8*i+1]);
    t2 = barrett_reduce(p->v[8*i+2]);
    t3 = barrett_reduce(p->v[8*i+3]);
    t4 = barrett_reduce(p->v[8*i+4]); //Make sure that coefficients have only 14 bits
    t5 = barrett_reduce(p->v[8*i+5]);
    t6 = barrett_reduce(p->v[8*i+6]);
    t7 = barrett_reduce(p->v[8*i+7]);

    m = t0 - PARAM_Q;
    c = m;
    c >>= 15;
    t0 = m ^ ((t0^m)&c); // <Make sure that coefficients are in [0,q]

    m = t1 - PARAM_Q;
    c = m;
    c >>= 15;
    t1 = m ^ ((t1^m)&c); // <Make sure that coefficients are in [0,q]

    m = t2 - PARAM_Q;
    c = m;
    c >>= 15;
    t2 = m ^ ((t2^m)&c); // <Make sure that coefficients are in [0,q]

    m = t3 - PARAM_Q;
    c = m;
    c >>= 15;
    t3 = m ^ ((t3^m)&c); // <Make sure that coefficients are in [0,q]


    m = t4 - PARAM_Q;
    c = m;
    c >>= 15;
    t4 = m ^ ((t4^m)&c); // <Make sure that coefficients are in [0,q]

    m = t5 - PARAM_Q;
    c = m;
    c >>= 15;
    t5 = m ^ ((t5^m)&c); // <Make sure that coefficients are in [0,q]

    m = t6 - PARAM_Q;
    c = m;
    c >>= 15;
    t6 = m ^ ((t6^m)&c); // <Make sure that coefficients are in [0,q]

    m = t7 - PARAM_Q;
    c = m;
    c >>= 15;
    t7 = m ^ ((t7^m)&c); // <Make sure that coefficients are in [0,q]

    p->v[(7*i)+0] = ((t0 & 0xff)<<8) | ((t0 >> 8) | ((  t1 << 6)& 0xff)) ;
    p->v[(7*i)+1] = ((t1 >> 2)<<8)   | ((t1 >> 10) | ((t2 << 4)& 0xff)) ;
    p->v[(7*i)+2] = ((t2 >> 4)<<8)   | ((t2 >> 12) | ((t3 << 2)& 0xff));
    p->v[(7*i)+3] = ((t3 >> 6)<<8)   | (t4 & 0xff);
    p->v[(7*i)+4] = (((t4 >> 8) | (t5 << 6))<<8)  | ((t5 >> 2) & 0xff); 
    p->v[(7*i)+5] = (((t5 >> 10) | (t6 << 4))<<8) | ((t6 >> 4) & 0xff);
    p->v[(7*i)+6] = (((t6 >> 12) | (t7 << 2))<<8) | ((t7 >> 6)& 0xff);
  }
}



void poly_uniform(poly *a, const unsigned char *seed)
{
  unsigned int pos=0, ctr=0;
  uint16_t val;
  uint64_t state[25];                   
  unsigned int nblocks=4;
  uint8_t buf[SHAKE128_RATE*nblocks];

  shake128_absorb_asm(state, seed, NEWHOPE_SEEDBYTES);
  
  shake128_squeezeblocks_asm((unsigned char *) buf, nblocks, state);

  while(ctr < PARAM_N)
  {
    val = (buf[pos] | ((uint16_t) buf[pos+1] << 8));
    if(val < 5*PARAM_Q)
      a->v[ctr++] = val;
    pos += 2;
    if(pos > SHAKE128_RATE*nblocks-2)
    {
      nblocks=1;
      shake128_squeezeblocks_asm((unsigned char *) buf,nblocks,state);
      pos = 0;
    }
  }
}

void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce)
{
#if PARAM_K != 16
#error "poly_getnoise in poly.c only supports k=16"
#endif

  unsigned char buf[PARAM_N];
  unsigned char n[8];
  int i,j,k;

  uint32_t *tp, t,d, a, b;
  tp = (uint32_t *) buf;

  for(i=1;i<8;i++)
    n[i] = 0;
  n[0] = nonce;
  for (k=0;k<4;k++){
      crypto_stream_chacha20(buf,PARAM_N,n,seed);

      for(i=0;i<PARAM_N/4;i++){

        t = tp[i];
        d = 0;
        for(j=0;j<8;j++){
          d += (t >> j) & 0x01010101;
        }
        a = ((d >> 8) & 0xff) + (d & 0xff);
        b = (d >> 24) + ((d >> 16) & 0xff);
        r->v[i+k*(PARAM_N/4)] = PARAM_Q + a - b;
      }
  }
}


void poly_bitrev(poly *r)
{
  bitrev_vector(r->v);
}


void poly_ntt(poly *r)
{
  asm_mulcoef_otf(r->v, omegas_montgomery); 
  asm_ntt((uint16_t *)r->v, omegas_montgomery);
}

void poly_invntt(poly *r)
{
  asm_ntt((uint16_t *)r->v, omegas_inv_montgomery);
  asm_mulcoef(r->v, psis_inv_montgomery);
}
