# Description


This directory provides the _NewHope_ key exchange scheme implementation optimized for the ARM Cortex-M4 processor and the underlying ARMv7-M architecture.

The code provided in this directory was developed and tested on the
 [STM32F4Discovery development board](http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/PF252419?sc=internet/evalboard/product/252419.jsp)


All carefully optimized assembly implementations can be found in the `newhope_asm.S` file. 

# Interaction

After the compilation, 4 tests can be performed. All those test are writen such that they end with an output stating _done_. If you do not see this message you should push the reset button on your development board. 


* Proof-of-concept binaries
    + Concept test: `make runNewhope` invokes the NewHope tests. It loads the code into the device memory and calls the monitor script to print the output of the device. This code runns both, the client and the server side of the key exchange and checks if the keys differ for both sides. If there is any difference an error message ( _Error in keys_ ) is printed, if not just _done_ is printed.

    + Communication test: `make runTestvectors` invokes the NewHope tests with testvectors. It loads the code into the device memory and calls the monitor script to print the output of the device.
      This code runns both, the client and the server side of the key exchange and prints all communication into the _outputvectors_ file. It then compares it with the _controlvectors_ file
      which we generated with the reference implementation. This test is done to proof that our implementation can communicate with the reference implementation.

* Measurment binaries
    + Speed measurements: `make runSpeed` invokes cycle count measurements. It loads the code into the device memory and calls the monitor script to print the output of the device.
    + Memory usage measurement: `make runMemsize` invokes the memory measurements. It loads the code into the device memory and calls the monitor script to print the output of the device. The ROM usage can be determined by running `arm-none-eabi-size -t tests/libnewhopearm.a`.
      



