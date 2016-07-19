#include <stdint.h>

#define ROUNDS 20

typedef uint32_t uint32;

static uint32 load_littleendian(const unsigned char *x)
{
  return
      (uint32) (x[0]) \
  | (((uint32) (x[1])) << 8) \
  | (((uint32) (x[2])) << 16) \
  | (((uint32) (x[3])) << 24)
  ;
}

static void store_littleendian(unsigned char *x,uint32 u)
{
  x[0] = u; u >>= 8;
  x[1] = u; u >>= 8;
  x[2] = u; u >>= 8;
  x[3] = u;
}

extern void chacha_perm_asm(uint32* out, uint32* in);
static int crypto_core_chacha20(
        unsigned char *out,
  const unsigned char *in,
  const unsigned char *k,
  const unsigned char *c
)
{
  int i;
  uint32 x[16];
  uint32 j[16];

  j[0]  = x[0]  = load_littleendian(c +  0);
  j[1]  = x[1]  = load_littleendian(c +  4);
  j[2]  = x[2]  = load_littleendian(c +  8);
  j[3]  = x[3]  = load_littleendian(c + 12);
  j[4]  = x[4]  = load_littleendian(k +  0);
  j[5]  = x[5]  = load_littleendian(k +  4);
  j[6]  = x[6]  = load_littleendian(k +  8);
  j[7]  = x[7]  = load_littleendian(k + 12);
  j[8]  = x[8]  = load_littleendian(k + 16);
  j[9]  = x[9]  = load_littleendian(k + 20);
  j[10] = x[10] = load_littleendian(k + 24);
  j[11] = x[11] = load_littleendian(k + 28);
  j[12] = x[12] = load_littleendian(in+  8);
  j[13] = x[13] = load_littleendian(in+ 12);
  j[14] = x[14] = load_littleendian(in+  0);
  j[15] = x[15] = load_littleendian(in+  4);


 chacha_perm_asm(x,x);

 for(i=0;i<16;i++)
 {
  store_littleendian(out + (4*i),x[i]+j[i]);
 }


  return 0;
}

static const unsigned char sigma[16] = "expand 32-byte k";
int crypto_stream_chacha20(unsigned char *c,unsigned long long clen, const unsigned char *n, const unsigned char *k)
{
  unsigned char in[16];
  unsigned char block[64];
  unsigned char kcopy[32];
  unsigned long long i;
  unsigned int u;

  if (!clen) return 0;

  for (i = 0;i < 32;++i) kcopy[i] = k[i];
  for (i = 0;i < 8;++i) in[i] = n[i];
  for (i = 8;i < 16;++i) in[i] = 0;

  while (clen >= 64) {
    crypto_core_chacha20(c,in,kcopy,sigma);

    u = 1;
    for (i = 8;i < 16;++i) {
      u += (unsigned int) in[i];
      in[i] = u;
      u >>= 8;
    }

    clen -= 64;
    c += 64;
  }

  if (clen) {
    crypto_core_chacha20(block,in,kcopy,sigma);
    for (i = 0;i < clen;++i) c[i] = block[i];
  }
  return 0;
}

