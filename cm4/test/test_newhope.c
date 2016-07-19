
#include "../stm32f4_wrapper.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../params.h"
#include "../poly.h"
#include "../newhope.h"

#define NTESTS 10


int main(void)
{
    clock_setup();
    gpio_setup();
    usart_setup(115200);
    rng_setup();

	int i;
	
	unsigned char output[32];

	poly sk;
	unsigned char key_a[32], key_b[32];
	unsigned char senda[NEWHOPE_SENDABYTES];
	unsigned char sendb[NEWHOPE_SENDBBYTES];
	for(i=0;i<NTESTS;i++)
	{
		/*send_USART_str((unsigned char *)"starting to keygen\n");*/
		newhope_keygen(senda,&sk);

		/*send_USART_str((unsigned char *)"starting to sharedb\n");*/
		newhope_sharedb(key_a,sendb,senda);
    
		/*send_USART_str((unsigned char *)"starting to shareda\n");*/
		newhope_shareda(key_b,&sk,sendb);
        
		if(memcmp(key_a,key_b,32))
		{
		  sprintf((char *)output, "Error in keys");
		  send_USART_str(output);
		}
	}
	sprintf((char *)output, "done!");
	send_USART_str(output);
    signal_host();
    return 0;
}
