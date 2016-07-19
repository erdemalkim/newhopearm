#include "poly.h"
#include "ntt.h"
#include "randombytes.h"
#include "fips202.h"
#include "crypto_stream_chacha20.h"
#include "stm32f4_wrapper.h"


void poly_frombytes(poly *r, const unsigned char *a)
{
  int i;
  for(i=0;i<PARAM_N/4;i++)
  {
    r->v[4*i+0] =                               a[7*i+0]        | (((uint16_t)a[7*i+1] & 0x3f) << 8);
    r->v[4*i+1] = (a[7*i+1] >> 6) | (((uint16_t)a[7*i+2]) << 2) | (((uint16_t)a[7*i+3] & 0x0f) << 10);
    r->v[4*i+2] = (a[7*i+3] >> 4) | (((uint16_t)a[7*i+4]) << 4) | (((uint16_t)a[7*i+5] & 0x03) << 12);
    r->v[4*i+3] = (a[7*i+5] >> 2) | (((uint16_t)a[7*i+6]) << 6); 
  }
}

void poly_tobytes(unsigned char *r, const poly *p)
{
  int i;
  uint16_t t0,t1,t2,t3,m;
  int16_t c;
  for(i=0;i<PARAM_N/4;i++)
  {
    t0 = barrett_reduce(p->v[4*i+0]); //Make sure that coefficients have only 14 bits
    t1 = barrett_reduce(p->v[4*i+1]);
    t2 = barrett_reduce(p->v[4*i+2]);
    t3 = barrett_reduce(p->v[4*i+3]);

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

    r[7*i+0] =  t0 & 0xff;
    r[7*i+1] = (t0 >> 8) | (t1 << 6);
    r[7*i+2] = (t1 >> 2);
    r[7*i+3] = (t1 >> 10) | (t2 << 4);
    r[7*i+4] = (t2 >> 4);
    r[7*i+5] = (t2 >> 12) | (t3 << 2);
    r[7*i+6] = (t3 >> 6);
  }
}

void poly_uniform(poly *a, const unsigned char *seed)
{
  unsigned int pos=0, ctr=0;
  uint16_t val;
  uint64_t state[25];
  unsigned int nblocks=4;
  uint8_t buf[SHAKE128_RATE*nblocks];

  shake128_absorb(state, seed, NEWHOPE_SEEDBYTES);
  
  shake128_squeezeblocks((unsigned char *) buf, nblocks, state);

  while(ctr < PARAM_N)
  {
    val = (buf[pos] | ((uint16_t) buf[pos+1] << 8)); 
    if(val < 5*PARAM_Q)
      a->v[ctr++] = barrett_reduce(val);
    pos += 2;
    if(pos > SHAKE128_RATE*nblocks-2)
    {
      nblocks=1;
      shake128_squeezeblocks((unsigned char *) buf,nblocks,state);
      pos = 0;
    }
  }
}

void poly_getnoise(poly *r, unsigned char *seed, unsigned char nonce)
{
#if PARAM_K != 16
#error "poly_getnoise in poly.c only supports k=16"
#endif

  unsigned char buf[4*PARAM_N];
  uint32_t *tp, t,d, a, b;
  unsigned char n[8];
  int i,j;

  tp = (uint32_t *) buf;

  for(i=1;i<8;i++)
    n[i] = 0;
  n[0] = nonce;

  crypto_stream_chacha20(buf,4*PARAM_N,n,seed);

  for(i=0;i<PARAM_N;i++)
  {
    t = tp[i];
    d = 0;
    for(j=0;j<8;j++)
      d += (t >> j) & 0x01010101;
    a = ((d >> 8) & 0xff) + (d & 0xff);
    b = (d >> 24) + ((d >> 16) & 0xff);
    r->v[i] = a + PARAM_Q - b;
  }
}

void poly_add(poly *r, const poly *a, const poly *b)
{
  int i;
  for(i=0;i<PARAM_N;i++)
    r->v[i] = barrett_reduce(a->v[i] + b->v[i]);
}

void poly_bitrev(poly *r)
{
  bitrev_vector(r->v);
}
void poly_ntt(poly *r)
{
  mul_coeff(r->v, omegas_montgomery); 
  ntt((uint16_t *)r->v, omegas_montgomery);
}

void poly_invntt(poly *r)
{
  ntt((uint16_t *)r->v, omegas_inv_montgomery);
  mul_coefficients(r->v,psis_inv_montgomery);
  
}

