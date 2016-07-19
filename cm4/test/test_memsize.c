
#include "../stm32f4_wrapper.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../params.h"
#include "../poly.h"
#include "../newhope.h"



#define MAXSTACK 50000
unsigned char key_a[32], key_b[32];
unsigned char senda[NEWHOPE_SENDABYTES];
unsigned char sendb[NEWHOPE_SENDBBYTES];
	

unsigned char output[32];
unsigned int ctr;
unsigned char canary;
volatile unsigned char *p;
extern unsigned char _end; 

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
{
    clock_setup();
    gpio_setup();
    usart_setup(115200);
    rng_setup();


	volatile unsigned char a; /* Mark the beginning of the stack */
	int i;
	poly sk;
    canary = 42;

    WRITE_CANARY(&a);
	newhope_keygen(senda,&sk);
    ctr = MAXSTACK - stack_count(canary,&a);
	sprintf((char *)output, "RAM usage of keygen: %d",ctr);
    send_USART_str(output);
	
	WRITE_CANARY(&a);
	newhope_sharedb(key_a,sendb,senda);
    ctr = MAXSTACK - stack_count(canary,&a);
	sprintf((char *)output, "RAM usage of sharedb: %d",ctr);
    send_USART_str(output);
	   


	WRITE_CANARY(&a);   
	newhope_shareda(key_b,&sk,sendb);
    ctr = MAXSTACK - stack_count(canary,&a);
	sprintf((char *)output, "RAM usage of shareda: %d",ctr);
    send_USART_str(output);
	      
	WRITE_CANARY(&a);
	newhope_keygen(senda,&sk);
 	newhope_sharedb(key_a,sendb,senda);
    newhope_shareda(key_b,&sk,sendb);
    ctr = MAXSTACK - stack_count(canary,&a);
	sprintf((char *)output, "RAM usage of KEM: %d",ctr);
    send_USART_str(output);
	
    sprintf((char *)output, "done!");
    send_USART_str(output);
    signal_host();

}
