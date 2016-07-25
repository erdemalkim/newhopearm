# NewHope for the ARM Cortex-M family of microcontrollers

Almost all asymmetric cryptography for the Web relies on the
hardness of factoring large integers or computing discrete logarithms. 
It is known that cryptography based on these problems will be broken in polynomial
time by Shor's algorithm once a large quantum computer is built. It is, however, unknown when this will be achieved, but there are several sources which assume large enough quantum computers
in the next 2 decades. In the majority of contexts the most critical asymmetric primitive to upgrade, to
resist attacks by quantum computers, is the **ephemeral key exchange**.

Alkim, Ducas, Pöppelmann, and Schwabe proposed such a protocol that they call _NewHope_. The _NewHope_ protocol provides the highest security level of post-quantum key exchanges, known to the authors. 
More details about the protocol can be found in the paper from the authors of [NewHope](https://cryptojedi.org/papers/newhope-20151207.pdf).

This repository contains the codes of a joint project with Philipp Jakubeit (phil.jakubeit@gmail.com) and Peter Schwabe (cryptojedi.org). Please use all names if you want to refer to this codes.

Within this repository, We provide two cycle count optimized versions of the key exchange. We used the ARM Cortex-M family as target architectures. To cover the whole range of that microcontroller family, we have to differentiate between two architectures:

* ARMv6-M 
* ARMv7-M

As representatives for the architectures we chose the ARM Cortex-M0 for the ARMv6-M architecture and the ARM Cortex-M4 for the ARMv7-M architecture. As we had to use two STMicroelectronics development boards with their own peculiarities we provide detailed instructions per target architecture in the related subdirectories. 

# API

The following API functions are provided for the key exchange:

* `newhope_keygen` (Server Side)
* `newhope_sharedb` (Client Side)
* `newhope_shareda` (Server Side)

Definitins of these functions can be found in the `newhope.[c,h]` files in both architecture specific directories.


This repository also provides optimized implementations of core building blocks gnerally used in ring-learning-with-error schemes, such as:

* The Number Theoretic Transform for n=1024 and q=12289 (`poly_ntt, poly_invntt`)
* The centered binomial noise generation for secrets (`poly_getnoise` for _ChaCha20_ implementation, `poly_getnoise_rng` for built-in RNG implementation on the Cortex-M4)
* Generating base polynomials by using _SHAKE-128_ (`poly_uniform`)



# Prerequisites


To build the code llvm and ARM gcc are needed. For a 
Debian System the following commands as should suffice:
```
apt-get install llvm gcc-arm-none-eabi
 
apt-get install libc6-dev-i386 

```

Additionally we need st-link. First the libusb headers are needed. 

```
apt-get install libusb-1.0-0-dev 
```
Then st-link must be downloaded and build:
```
git clone https://github.com/texane/stlink.git
cd stlink
./autogen.sh
./configure
make && make install 
```

The path to the st-flash binary from the st-link utility needs to be set manually in the first line of the make file to `STFLASH=/your/stlink/path/st-flash`.

To communicate serially with one of the boards a USB-TTL converter is 
needed. It needs to be connected to each board as follows:

* 3.3V → 3.3V
* TXD → PA3
* RXD → PA2
* GND → GND
* 5V → DO NOT CONNECT


# Usage

To compile a project, you should use the `make` command. This command builds four binaries and one archive file in test directory. These binaries can be divided into two categories, two being proof-of-concept tests and two being measurement. Each of those binaries can be uploaded to the microcontroller by dedicated make file targets specified in the subdirectories. 



# Used packages


We based our work on the following implementations:

* Both, `stm32f0_wrapper.c` and `stm32_wrapper.h` are taken from 
[Joost Rijneveld's](https://github.com/joostrijneveld/STM32-getting-started) implementation. 

* The libopencm3 directories and developmenmt board specific linker scripts are 
from the [Libopencm3 Library](http://www.libopencm3.org/wiki/Main_Page),
we only modified includes to provide a stand alone version.

The `keccakf1600.s` files are architecture specific and taken from the [Keccak Code Package](https://github.com/gvanas/KeccakCodePackage). We removed unused code to fit it on the target devices.


## Other packages

* The [STM32f0xx](http://munacl.cryptojedi.org/curve25519-cortexm0.shtml) package, from the MCD Application Team, provided inside the Cortex-M0 subdirectory is used for the measurement binaries.

* The _CHACHA_ implementation for the Cortex-M4 is taken from Joost Rijneveld's [ARMed SPHINCS](https://joostrijneveld.nl/papers/armedsphincs/) paper. 



# Disclaimer

The software for the Cortex-M0 provided in the cm0 subdirectory is a proof of concept 
and not intended for actual deployment. The random 
seed generation needs to be apapted such that a true random source 
is used for the seeds. This could be realized by integrating the 
random number generator into the 'randombytes' function inside 
'randombytes.c'.
