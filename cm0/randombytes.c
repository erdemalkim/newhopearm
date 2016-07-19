#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "randombytes.h"

/* Should be replaced by a secure source of randomness followed by a call to SHA-3*/


void randombytes(unsigned char *x,unsigned long long xlen)
{
  int i;
  unsigned char a[32] = {160,168,20,235,215,132,214,153,241,122,10,29,232,59,88,218,161,54,250,5,108,190,135,52,243,20,150,168,242,201,99,202};
  unsigned char b[32] = {123,191,73,222,176,209,3,73,220,117,251,159,99,65,99,133,31,35,236,102,76,23,91,24,201,253,69,169,172,43,4,0};
  unsigned char c[32] = {46,202,34,101,97,180,47,34,48,181,211,80,44,146,180,168,173,17,189,131,36,44,249,222,248,63,227,115,153,173,176,148};  

  
  if (xlen == 0){
    for (i=0;i<32;i++){
        x[i] = a[i]; 
    }
  }
  else if (xlen ==1){
     for (i=0;i<32;i++){
        x[i] = b[i]; 
    }  
  }
  else{
     for (i=0;i<32;i++){
        x[i] = c[i]; 
    }
  }

  //return sha3256(x, result_of_RNG, 32);

}

