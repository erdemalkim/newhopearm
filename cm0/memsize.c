#include "stm32wrapper.h"
#include <stdlib.h>
#include "params.h"
#include "poly.h"
#include "newhope.h"
#include "print.h"




//unsigned char senda[NEWHOPE_SENDABYTES];
//unsigned char sendb[NEWHOPE_SENDBBYTES];
	

#define MAXSTACK 3800






static unsigned int stack_count(unsigned char canary,volatile unsigned char *a)
{
  volatile unsigned char *p = (a-MAXSTACK);
  unsigned int c = 0;
  while(*p == canary && p < a)
  {
    p++;
    c++;
  }
  return c;
} 

#define WRITE_CANARY(X) {p=X;while(p>= (X-MAXSTACK)) *(p--) = canary;}
 
int main(void)
{unsigned char canary;
volatile unsigned char *p;
  volatile unsigned char a; /* Mark the beginning of the stack */
unsigned int ctr;
poly sk,temp;
unsigned char key_a[32], key_b[32];
  //randombytes(&canary,1);
  canary = 42;


	WRITE_CANARY(&a);   
	newhope_shareda(key_a,&sk,&sk);
    ctr = MAXSTACK - stack_count(canary,&a);
  print_stack("SharedA",-1,ctr);

  WRITE_CANARY(&a);
  newhope_sharedb(key_b,&sk,&sk);
  ctr = MAXSTACK - stack_count(canary,&a);
  print_stack("SharedB",-1,ctr);

	WRITE_CANARY(&a);
	newhope_keygen(&sk,&temp);
    ctr = MAXSTACK - stack_count(canary,&a);
  print_stack("Keygen",-1,ctr);


	WRITE_CANARY(&a);
	newhope_shareda(key_a,&sk,&sk);
  newhope_sharedb(key_b,&sk,&sk);
	newhope_keygen(&sk,&temp);
    ctr = MAXSTACK - stack_count(canary,&a);
  print_stack("KEM",-1,ctr);

  write_byte(4);
  while(1);
}



