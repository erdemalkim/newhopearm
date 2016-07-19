#include "poly.h"
#include "randombytes.h"
#include "fips202.h"
#include "newhope.h"


static void encode_ap(poly *pk, const unsigned char *seed)
{
  int i;
  poly_densify(pk);
  for(i=0;i<NEWHOPE_SEEDBYTES/2;i++){
    pk->v[(POLY_BYTES/2)+i] = (seed[i*2]<<8)|seed[(i*2)+1];
  }
}



static void decode_ap(poly *pk, unsigned char *seed)
{
  int i;
  for(i=0;i<NEWHOPE_SEEDBYTES/2;i++){
    seed[i*2] = pk->v[(POLY_BYTES/2)+i] >> 8;
    seed[(i*2)+1] = pk->v[(POLY_BYTES/2)+i] & 0xff;
  }

  poly_amplify(pk);
}




static void encode_bp(poly *b, poly *c)
{
  int i;
  poly_densify(b);
  for(i=0;i<PARAM_N/8;i++)
    b->v[(POLY_BYTES/2)+i] = (c->v[8*i+4] | (c->v[8*i+5] << 2) | (c->v[8*i+6] << 4) | (c->v[8*i+7] << 6))| (c->v[8*i] | (c->v[8*i+1] << 2) | (c->v[8*i+2] << 4) | (c->v[8*i+3] << 6))<<8  ;
}



static void decode_bp(poly *b, poly *c)
{
  int i;
  for(i=0;i<PARAM_N/8;i++)
  {
    c->v[8*i+0] = (b->v[(POLY_BYTES/2)+i] >> 8) & 0x03;
    c->v[8*i+1] = (b->v[(POLY_BYTES/2)+i] >> 10)& 0x03;
    c->v[8*i+2] = (b->v[(POLY_BYTES/2)+i] >> 12)& 0x03;
    c->v[8*i+3] = (b->v[(POLY_BYTES/2)+i] >> 14);
    c->v[8*i+4] =  b->v[(POLY_BYTES/2)+i]       & 0x03;
    c->v[8*i+5] = (b->v[(POLY_BYTES/2)+i] >> 2) & 0x03;
    c->v[8*i+6] = (b->v[(POLY_BYTES/2)+i] >> 4) & 0x03;
    c->v[8*i+7] = (b->v[(POLY_BYTES/2)+i] >> 6) & 0x03;

  }
  poly_amplify(b);
}

// non static just for cycle count
//static void gen_a(poly *a, const unsigned char *seed)
void gen_a(poly *a, const unsigned char *seed)
{
    poly_uniform(a,seed);
}


// API FUNCTIONS 

void newhope_keygen_internal(poly * s, poly *sk, unsigned char * seed)
{
  poly a;
  unsigned char noiseseed[NEWHOPE_SEEDBYTES];

  randombytes(noiseseed, 1);


  gen_a(&a, seed); //unsigned

  poly_getnoise(sk,noiseseed,0);
  poly_ntt(sk); //unsigned
  
  poly_getnoise(s,noiseseed,1);
  poly_ntt(s); //unsigned

  asm_poly_pointwise(&a,sk,&a); //unsigned
  asm_poly_add(s,&a); //unsigned


}
void newhope_keygen(poly *send, poly *sk)
{
    unsigned char  seed[NEWHOPE_SEEDBYTES];

    randombytes(seed, 2);
    newhope_keygen_internal(send, sk,seed);

    encode_ap(send, seed);
}



void newhope_sharedb_internal(unsigned char *sharedkey, poly *send, poly *received)
{
  poly a;
  unsigned char seed[NEWHOPE_SEEDBYTES];
  unsigned char noiseseed[32];
    int i;
  
  randombytes(noiseseed, 0);


  decode_ap(received,seed);



  gen_a(&a, seed);

  poly_getnoise(send,noiseseed,0);
  poly_ntt(send);


  asm_poly_pointwise(&a, &a, send);
 
  asm_poly_pointwise(send, received, send );
  poly_bitrev(send);
  poly_invntt(send);

  poly_getnoise(received,noiseseed,2);
  asm_poly_add(send, received);


  poly_getnoise(received,noiseseed,1);
  poly_ntt(received);

  asm_poly_add(&a, received);

  helprec(received, send, noiseseed, 3);


  
  asm_rec(sharedkey, send, received);


  for(i = 0;i<1024;i++){
    send->v[i] = a.v[i];  
  }

  sha3256(sharedkey, sharedkey, 32);

}

void newhope_sharedb(unsigned char *sharedkey, poly *send, poly *received){
    
  newhope_sharedb_internal(sharedkey, send, received);

  encode_bp(send, received);

}

void newhope_shareda(unsigned char *sharedkey, poly *sk, poly *received)
{
  poly c;



  decode_bp(received,&c);


  asm_poly_pointwise(sk,sk,received);
  poly_bitrev(sk);
  poly_invntt(sk);
 
  asm_rec(sharedkey, sk, &c);
  sha3256(sharedkey, sharedkey, 32); 

}
