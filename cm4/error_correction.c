#include "error_correction.h"

//See paper for details on the error reconciliation

static int32_t abs(int32_t v)
{
  int32_t mask = v >> 31;
  return (v ^ mask) - mask;
}


static int32_t f(int32_t *v0, int32_t *v1, int32_t x)
{
  int32_t xit, t, r, b;
  
  // Next 6 lines compute t = x/PARAM_Q;
  b = x*2730;
  t = b >> 25;
  b = x - t*12289;
  b = 12288 - b;
  b >>= 31;
  t -= b;

  r = t & 1;
  xit = (t>>1);
  *v0 = xit+r; // v0 = round(x/(2*PARAM_Q))

  t -= 1;
  r = t & 1;
  *v1 = (t>>1)+r;

  return abs(x-((*v0)*2*PARAM_Q));
}

static int32_t g(int32_t x)
{
  int32_t t,c,b;

  // Next 6 lines compute t = x/(4*PARAM_Q);
  b = x*2730;
  t = b >> 27;
  b = x - t*49156;
  b = 49155 - b;
  b >>= 31;
  t -= b;

  c = t & 1;
  t = (t >> 1) + c; // t = round(x/(8*PARAM_Q))

  t *= 8*PARAM_Q;

  return abs(t - x);
}


static int16_t LDDecode(int32_t xi0, int32_t xi1, int32_t xi2, int32_t xi3)
{
  int32_t t;

  t  = g(xi0);
  t += g(xi1);
  t += g(xi2);
  t += g(xi3);

  t -= 8*PARAM_Q;
  t >>= 31;
  return t&1;
}


void helprec(poly *c, const poly *v, const unsigned char *seed, unsigned char nonce)
{
  int32_t v0[4], v1[4], v_tmp[4], k;
  unsigned char rbit;
  unsigned char rand[32];
  unsigned char n[8];
  int i;

  for(i=0;i<7;i++)
	n[i] = 0;
  n[7] = nonce;

  /*randombytes(rand,32);*/
  crypto_stream_chacha20(rand,32,n,seed);
 
  for(i=0; i<256; i++)
  {
    rbit = (rand[i>>3] >> (i&7)) & 1;

    k  = f(v0+0, v1+0, 8*v->v[  0+i] + 4*rbit);
    k += f(v0+1, v1+1, 8*v->v[256+i] + 4*rbit);
    k += f(v0+2, v1+2, 8*v->v[512+i] + 4*rbit);
    k += f(v0+3, v1+3, 8*v->v[768+i] + 4*rbit);

    k = (2*PARAM_Q-1-k) >> 31;

    v_tmp[0] = ((~k) & v0[0]) ^ (k & v1[0]);
    v_tmp[1] = ((~k) & v0[1]) ^ (k & v1[1]);
    v_tmp[2] = ((~k) & v0[2]) ^ (k & v1[2]);
    v_tmp[3] = ((~k) & v0[3]) ^ (k & v1[3]);

    c->v[  0+i] = (v_tmp[0] -   v_tmp[3]) & 3;  
    c->v[256+i] = (v_tmp[1] -   v_tmp[3]) & 3;
    c->v[512+i] = (v_tmp[2] -   v_tmp[3]) & 3;
    c->v[768+i] = (   -k    + 2*v_tmp[3]) & 3;
  }
}


void rec(unsigned char *key, const poly *v, const poly *c)
{
  int i;
  int32_t tmp[4];

  for(i=0;i<32;i++)
    key[i] = 0;

  for(i=0; i<256; i++)
  {
    tmp[0] = 16*PARAM_Q + 8*(int32_t)v->v[  0+i] - PARAM_Q * (2*c->v[  0+i]+c->v[768+i]);
    tmp[1] = 16*PARAM_Q + 8*(int32_t)v->v[256+i] - PARAM_Q * (2*c->v[256+i]+c->v[768+i]);
    tmp[2] = 16*PARAM_Q + 8*(int32_t)v->v[512+i] - PARAM_Q * (2*c->v[512+i]+c->v[768+i]);
    tmp[3] = 16*PARAM_Q + 8*(int32_t)v->v[768+i] - PARAM_Q * (              c->v[768+i]);

    key[i>>3] |= LDDecode(tmp[0], tmp[1], tmp[2], tmp[3]) << (i & 7);
  }
}
