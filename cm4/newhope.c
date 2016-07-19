#include "poly.h"
#include "randombytes.h"
#include "error_correction.h"
#include "fips202.h"

 /*#define poly_getnoise poly_getnoise_fast*/

static void encode_a(unsigned char *r, const poly *pk, const unsigned char *seed)
{
  int i;
  poly_tobytes(r, pk);
  for(i=0;i<NEWHOPE_SEEDBYTES;i++)
    r[POLY_BYTES+i] = seed[i];
}

static void decode_a(poly *pk, unsigned char *seed, const unsigned char *r)
{
  int i;
  poly_frombytes(pk, r);
  for(i=0;i<NEWHOPE_SEEDBYTES;i++)
    seed[i] = r[POLY_BYTES+i];
}

static void encode_b(unsigned char *r, const poly *b, const poly *c)
{
  int i;
  poly_tobytes(r,b);
  for(i=0;i<PARAM_N/4;i++)
    r[POLY_BYTES+i] = c->v[4*i] | (c->v[4*i+1] << 2) | (c->v[4*i+2] << 4) | (c->v[4*i+3] << 6);
}

static void decode_b(poly *b, poly *c, const unsigned char *r)
{
  int i;
  poly_frombytes(b, r);
  for(i=0;i<PARAM_N/4;i++)
  {
    c->v[4*i+0] =  r[POLY_BYTES+i]       & 0x03;
    c->v[4*i+1] = (r[POLY_BYTES+i] >> 2) & 0x03;
    c->v[4*i+2] = (r[POLY_BYTES+i] >> 4) & 0x03;
    c->v[4*i+3] = (r[POLY_BYTES+i] >> 6);
  }
}


static void gen_a(poly *a, const unsigned char *seed)
{
    poly_uniform(a,seed);
}


// API FUNCTIONS 

void newhope_keygen(unsigned char *send, poly *sk)
{
  poly a, pk;
  unsigned char seed[NEWHOPE_SEEDBYTES];
  unsigned char noiseseed[32];

  randombytes(seed, NEWHOPE_SEEDBYTES);
  randombytes(noiseseed, 32);

  gen_a(&a, seed); //unsigned

  poly_getnoise(sk,noiseseed,0);
  poly_ntt(sk); //unsigned
  
  poly_getnoise(&pk,noiseseed,1);
  poly_ntt(&pk); //unsigned

  poly_pointwise(&a,&a,sk); //unsigned
  poly_add(&pk,&a,&pk); //unsigned
  encode_a(send, &pk, seed);
}

void newhope_sharedb(unsigned char *sharedkey, unsigned char *send, const unsigned char *received)
{
  poly sp, v, a;
  unsigned char seed[NEWHOPE_SEEDBYTES];
  unsigned char noiseseed[32];
  
  randombytes(noiseseed, 32);

  decode_a(&v, seed, received);
  gen_a(&a, seed);

  poly_getnoise(&sp,noiseseed,0);
  poly_ntt(&sp);
 
  poly_pointwise(&a, &a, &sp);
  poly_pointwise(&v, &v, &sp);
  
  poly_getnoise(&sp,noiseseed,1);
  poly_ntt(&sp);

  poly_add(&a, &a, &sp);
  
  poly_bitrev(&v);
  poly_invntt(&v);

  poly_getnoise(&sp,noiseseed,2);
  poly_add(&v, &v, &sp);

  helprec(&sp, &v, noiseseed, 3);

  encode_b(send, &a, &sp);
  
  rec(sharedkey, &v, &sp);

  sha3256(sharedkey, sharedkey, 32);
}


void newhope_shareda(unsigned char *sharedkey, const poly *sk, const unsigned char *received)
{
  poly v, c;

  decode_b(&v, &c, received);

  poly_pointwise(&v,sk,&v);
  poly_bitrev(&v);
  poly_invntt(&v);
 
  rec(sharedkey, &v, &c);
  sha3256(sharedkey, sharedkey, 32);
}
