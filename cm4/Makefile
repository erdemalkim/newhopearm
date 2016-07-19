# You can define your st-link directory in here
STFLASH=$(HOME)/stlink/st-flash



LDSF4=stm32f407x6.ld
F4FLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -MD -DSTM32F4

LDSCRIPT = $(LDSF4)
CC=gcc
PREFIX	?= arm-none-eabi
ARMCC	= $(PREFIX)-$(CC)
LD		= $(PREFIX)-$(CC)
OBJCOPY	= $(PREFIX)-objcopy
OBJDUMP	= $(PREFIX)-objdump
GDB		= $(PREFIX)-gdb

OPENCM3DIR = ./libopencm3

ARCH_FLAGS = $(F4FLAGS)
CFLAGS		+= -Ofast \
			   -I$(OPENCM3DIR)/include \
			   -fno-common 
LDFLAGS		+= --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
			   -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections \
			   $(ARCH_FLAGS)

OBJFILES  = newhope_asm.o precomp.o poly.o error_correction.o newhope.o fips202.o stm32f4_wrapper.o keccakf1600.o chacha.o crypto_stream_chacha20.o

all: lib \
	test/test_newhope.bin \
	test/test_memsize.bin \
	test/speed.bin \
	


lib: $(OBJFILES) randombytes.o
	$(PREFIX)-ar cq test/libnewhopearm.a $(OBJFILES) randombytes.o
	@rm *.o *.d

runMemsize: test/monitor.sh test/test_memsize.bin
	@echo "Writing Memsize binary to devices" 
	@./test/monitor.sh $(STFLASH) test/test_memsize.bin 

runNewhope: test/monitor.sh test/test_newhope.bin
	@echo "Writing Newhope binary to devices"
	@./test/monitor.sh $(STFLASH) test/test_newhope.bin

runTestvectors: test/monitor test/testvectors.bin
	@echo "Writing Testvectors binary to devices" 
	@$(STFLASH) write test/testvectors.bin 0x8000000 >/dev/null 2>&1
	./test/monitor > test/outputvectors
	diff test/outputvectors test/controlvectors >> /dev/null && echo "\ndone\n"

runSpeed: test/monitor.sh test/speed.bin
	@echo "Writing Speed binary to devices" 
	@./test/monitor.sh $(STFLASH) test/speed.bin

test/testvectors.bin: test/testvectors.elf
	$(OBJCOPY) -Obinary test/testvectors.elf test/testvectors.bin

test/testvectors.elf: test/testvectors.o $(LDSCRIPT) test/libnewhopearm.a 
	$(LD) -o test/testvectors.elf test/testvectors.o test/libnewhopearm.a $(LDFLAGS) libopencm3/lib/libopencm3_stm32f4.a

test/monitor: test/monitor.c
	$(CC) -o test/monitor test/monitor.c

%.bin: %.elf
		$(OBJCOPY) -Obinary $(*).elf $(*).bin

%.elf: %.o $(LDSCRIPT) test/libnewhopearm.a 
		$(LD) -o $(*).elf  $(*).o test/libnewhopearm.a $(LDFLAGS) libopencm3/lib/libopencm3_stm32f4.a

%.o: %.c 
		$(ARMCC) $(CFLAGS) $(ARCH_FLAGS) -o $@ -c $<

%.o: %.S 
		$(ARMCC) $(CFLAGS) $(ARCH_FLAGS) -o $@ -c $<

stm32f4_wrapper.o: stm32f4_wrapper.c
		$(ARMCC) $(CFLAGS) $(ARCH_FLAGS) -Wno-overflow -o $@ -c $<




.PHONY: clean

clean:
	@rm -f test/monitor
	-rm -f test/*.elf
	@rm -f test/*.celf
	@rm -f test/*.d
	-rm -f test/*.bin
	@rm -f test/*.o
	-rm -f *.o
	@rm -f test/*.a
	@rm -f *.o
	-rm -f *.d
	@rm -f test/outputvectors
