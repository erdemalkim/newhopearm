#include "../newhope.h"
#include "../poly.h"
#include "../stm32f4_wrapper.h"
#include <stdlib.h>
#include <stdio.h>

#define NTESTS 2


static void print_results(const char *s, unsigned int *t, size_t tlen)
{
  unsigned char output[32];
  sprintf((char *)output,"%s", s);
  send_USART_str(output);
  sprintf((char *)output,"median: %u",t[1]-t[0]);
  send_USART_str(output);
}

#define cpucycles() (*DWT_CYCCNT);

unsigned int t[NTESTS];

int main()
{
  clock_setup();
  gpio_setup();
  usart_setup(115200);
  rng_setup();
  volatile unsigned int *DWT_CYCCNT = (unsigned int *)0xE0001004;
  volatile unsigned int *DWT_CTRL = (unsigned int *)0xE0001000;
  volatile unsigned int *SCB_DEMCR = (unsigned int *)0xE000EDFC;

  *SCB_DEMCR = *SCB_DEMCR | 0x01000000;
  *DWT_CYCCNT = 0; // reset the counter
  *DWT_CTRL = *DWT_CTRL | 1 ; // enable the counter
  uint32_t urnd[1024];
  unsigned char output[32];
  poly sk_a;
  unsigned char key_a[32], key_b[32];
  unsigned char senda[POLY_BYTES];
  unsigned char sendb[POLY_BYTES];
  unsigned char seed[NTESTS*32];
  int i;

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    randombytes(seed, 32);
    poly_uniform(&sk_a, seed);
  }
  print_results("poly_uniform: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    poly_ntt(&sk_a);
  }
  print_results("poly_ntt: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    poly_bitrev(&sk_a);
    poly_invntt(&sk_a);
  }
  print_results("poly_invntt: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    poly_getnoise(&sk_a,seed,0);
  }
  print_results("poly_getnoise: ", t, NTESTS);
  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    poly_getnoise_fast(&sk_a,seed,0);
  }
  print_results("poly_getnoise_fast: ", t, NTESTS);

 for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    random_int(urnd,1024);
  }
  print_results("random: ", t, NTESTS);
  
  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    helprec(&sk_a, &sk_a, seed, 0);
  }
  print_results("helprec: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    rec(key_a, &sk_a, &sk_a);
  }
  print_results("rec: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    newhope_keygen(senda, &sk_a);
  }
  print_results("newhope_keygen: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    newhope_sharedb(key_b, sendb, senda);
  }
  print_results("newhope_sharedb: ", t, NTESTS);

  for(i=0; i<NTESTS; i++)
  {
    t[i] = cpucycles();
    newhope_shareda(key_a, &sk_a, sendb);
  }
  print_results("newhope_shareda: ", t, NTESTS);
    
  sprintf((char *)output, "done");
  send_USART_str(output);
  signal_host();
 
  return 0;
}
