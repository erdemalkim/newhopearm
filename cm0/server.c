#include "stm32wrapper.h"
#include "newhope.h"
#include "constants.c"


#define NTESTS 1

void init_dma(int baud){
    clock_setup();
    gpio_setup();
    usart_setup(baud);
    dma_transmit_setup();
    dma_request_setup();

}

void check_key(unsigned char *key_a){
  char out[6];
  out[5] = '\0';
  int i,e=1;
  signal_host();
  for (i=0;i<32;i++){
    if(key_a[i] != key_stored[i]){
      out[0] = 'E';
      out[1] = 'r';
      out[2] = 'r';
      out[3] = 'o';
      out[4] = 'r';
      e= 0;
    }
  } 
  if(e){
    out[0] = 'D';
    out[1] = 'o';
    out[2] = 'n';
    out[3] = 'e';
    out[4] = '!';
  }
  dma_transmit(out, 6); while (!dma_done());
}

void send_x(poly *sendx){
  unsigned char sendbytes[256];
  char out[5];
  int i,j;
  signal_host();
  for(i=0;i<1024;i+=128){
    for (j=0;j<256;j+=2){
      sendbytes[j] = sendx->v[i+j/2]  >> 8;
      sendbytes[j+1] = sendx->v[i+j/2]& 0xff;
    }
    dma_transmit(sendbytes, 256); while (!dma_done());
  }
}

void request(poly *sendx){
  unsigned char sendbytes[256];
  int i=0,j;
  
  for(i=0;i<1024;i+=128){
    signal_host();
    dma_request(sendbytes, 256); while (!dma_done());
    for (j=0;j<256;j+=2){
      sendx->v[i+(j/2)] = sendbytes[j+1] | (uint16_t)sendbytes[j] << 8; 
    }
 }

}

int test_keys(){
  poly send,sk_a;
  uint16_t i,e=1;
  unsigned char key_a[32];

  
  newhope_keygen(&send, &sk_a);
  send_x(&send);
  request(&send);
  newhope_shareda(key_a, &sk_a, &send);
  check_key(key_a);
  return 0;
}
    


int main(){
  init_dma(921600);
  test_keys();



  while(1);
}
