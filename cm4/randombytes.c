#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include "randombytes.h"
#include "stm32f4_wrapper.h"


void randombytes(unsigned char *x,unsigned long long xlen)
{
  rng_setup();
  random_int((uint32_t *)x,xlen/4);
}
