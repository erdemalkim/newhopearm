#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "params.h"
#include "ntt.h"
#include "print.h"
#include "newhope.h"
#include "stm32f0xx/stm32f0xx.h"


int main(void){
  SysTick_Config(12000000);
  
  int ini, fin,i,all=0;
  char out[16];
  unsigned char send[PARAM_N*2];
  poly p;


 unsigned char seed[NEWHOPE_SEEDBYTES] = {189, 177, 112, 96, 11, 152, 84, 4, 17, 84, 18, 110, 43, 17, 125, 74, 105, 241, 84, 92, 62, 149, 210, 82, 222, 30, 114, 183, 172, 104, 152, 25};
unsigned char sharedkey[32];

SysTick->VAL = 0;
  ini= SysTick->VAL;
   newhope_keygen(&p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "Keygen:\t\t\t %d\n|\n",fin-2);
  print(out);


for (i=0;i<100;i++){
SysTick->VAL = 0;
  ini= SysTick->VAL;
  gen_a(&p, seed);
  fin= SysTick->VAL;

  all += ini-fin;
}
fin = all/100;
  sprintf(out, "|---Gen_a:\t\t  %d ASM\n",fin-2);
  print(out);



SysTick->VAL = 0;
  ini= SysTick->VAL;
  poly_getnoise(&p,seed,0);
  fin= SysTick->VAL;

  fin = ini-fin;

  sprintf(out, "|---Get Noise:\t\t  %d ASM\n",fin-2);
  print(out);
     //unsigned



SysTick->VAL = 0;
  ini= SysTick->VAL;
  poly_ntt(&p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---NTT:\t\t  %d ASM\n",fin-2);
  print(out);

SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_mulcoef_otf(p.v, psis_bitrev_montgomery); 
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "    |---MULCOEFOTF:\t   %d ASM\n",fin-2);
  print(out);

SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_mulcoef(p.v, psis_bitrev_montgomery); 
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "    |---MULCOEF:\t   %d ASM\n",fin-2);
  print(out);




SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_ntt((uint16_t *)p.v, omegas_montgomery);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "    |---NTTC:\t\t  %d ASM\n",fin-2);
  print(out);

SysTick->VAL = 0;
  ini= SysTick->VAL;
  test_doublefly(&p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "        |---Doublefly:\t     %d ASM\n",fin-2);
  print(out);


SysTick->VAL = 0;
  ini= SysTick->VAL;
  test_butterfly(&p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "        |---Butterfly:\t      %d ASM\n",fin-2);
  print(out);

SysTick->VAL = 0;
  ini= SysTick->VAL;
  test_lazy_butterfly(&p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "        |---Lazy Butterfly:   %d ASM\n",fin-2);
  print(out);
  


  


  


SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_poly_pointwise(&p,&p,&p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Pointwise:\t\t   %d ASM\n",fin-2);
  print(out);



SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_poly_add(&p,&p); 
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Add:\t\t   %d ASM\n",fin-2);
  print(out);








SysTick->VAL = 0;
  ini= SysTick->VAL;
  newhope_shareda(sharedkey, &p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "\n\nShared A:\t\t  %d\n|\n",fin-2);
  print(out);

  

SysTick->VAL = 0;
  ini= SysTick->VAL;
  poly_bitrev(&p); 
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Bitrev:\t\t   %d\n",fin-2);
  print(out);
  


 #define asm_rec asm_rec
extern void asm_rec(unsigned char *key, const poly * b, const poly *p);
  SysTick->VAL = 0;
  ini= SysTick->VAL;
  asm_rec(sharedkey, &p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Rec:\t\t   %d ASM\n",fin-2);
  print(out);

 SysTick->VAL = 0;
  ini= SysTick->VAL;
  sha3256(sharedkey, sharedkey, 32);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Sha3256:\t\t   %d ASM\n",fin-2);
  print(out);

  
SysTick->VAL = 0;
  ini= SysTick->VAL;
  newhope_sharedb(sharedkey, &p, &p);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "\n\nShared B:\t\t %d\n|\n",fin-2);
  print(out);



 
SysTick->VAL = 0;
  ini= SysTick->VAL;
  helprec(&p, &p, seed, 3);
  fin= SysTick->VAL;

  fin = ini-fin;
  sprintf(out, "|---Helprec:\t\t   %d ASM\n",fin-2);
  print(out);
  


  print("\n");
  write_byte(4);
  while(1);
}

void SysTick_Handler(void)
{
  ;
}
