The codes in this directory are written by Philipp Jakubeit (phil.jakubeit@gmail.com). Please
refer to him if you want to use this codes.

This directory contains the first release of the Newhope key-exchange  
scheme optimized for the Cortex-M0 and the underlying ARMv6-M 
architecture. Further refered to as NH4CM0 inside this document.

The software provided in this directory makes use of TWO external 
libraries. The STM32f00 files provided inside the directory, which 
are only used for cycle counts. The client and server code make 
use of the 'libopencm3' library. Its relevant files are included
inside this directory into the 'libopencm3' sub directory.

Building
--------

If you want to build NH4CM0 just type 'make' to build the program.
This should compile the program in the current directory. It will 
generate four binaries [client.bin, server.bin,speed.bin,memsize.bin]. 


Uploading
---------

For each of those binaries a corresponding script can be found in 
the directory. By executing a script the binary gets uploaded to 
the Cortex-M0. Each script expects the Cortex-M0 at '/dev/ttyUSB0'. 
If the device is connected at a different place you have to adapt 
the scripts accordingly. 

The client and the server scripts will complete without any further 
notification. The scripts uploading the binary for speed or memory
measurements will print their output directly to the terminal. 


Interacting
-----------

To interact with the Cortex-M0 either in server or in client mode 
depending on the script uploaded, we provide two python scripts. 
These can be found in the 'Host Side' subdirectory. They are named 
similar to the upload scripts except the ".py" fle extension. The 
idea is to execute one of the python script and than upload the code
to the M0 or reset the M0 to reinitiate the software.



Nota bene
---------
The software provided in this directory is a proof of concept 
and not intended for actual deployment. If one would like to 
use the software one has to perform at least two crucial changes.
First the functions in newhope.c, where mentioned, are required to 
be changed to static. Second and even more crucial does the random 
seed generation needs to be apapted such that a true random source 
is used for the seeds. This could be realized by integrating the 
random number generator into the 'randombytes' function inside 
'randombytes.c'.

  



