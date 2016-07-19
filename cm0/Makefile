STFLASH=st-flash

LDSCRIPT = stm32f0-discovery.ld

PREFIX	?= arm-none-eabi
LD		= $(PREFIX)-gcc
OBJCOPY	= $(PREFIX)-objcopy
OBJDUMP	= $(PREFIX)-objdump
GDB		= $(PREFIX)-gdb
INCDIRS=-I./stm32f0xx

LINKERFILE = stm32f0xx/stm32f0_linker.ld 

ARCH_FLAGS = -mthumb -mcpu=cortex-m0 -msoft-float
CFLAGS		+= -Ofast \
		   -Wredundant-decls\
		   -Wundef -Wshadow \
		   -fno-common $(ARCH_FLAGS) -MD -DSTM32F0 \
		   -s\
		   -Wl,--gc-sections\
		   -nostdlib
LDFLAGS		+= --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
		   -T$(LDSCRIPT) -nostartfiles -Wl,--gc-sections,--print-gc-sections \
		   $(ARCH_FLAGS) 


STMOBJ = stm32f0xx/system_stm32f0xx.o  \
         stm32f0xx/stm32f0xx_gpio.o  \
         stm32f0xx/stm32f0xx_rcc.o  \
         stm32f0xx/stm32f0xx_usart.o  \
         stm32f0xx/startup_stm32f0xx.o \
				 stm32f0xx/sbrk.o

OBJS = ntt.o reduce.o poly.o  error_correction.o crypto_stream_chacha20.o newhope.o fips202.o stm32f0_wrapper.o randombytes.o asm_poly.o asm_ntt.o asm_ec.o asm_KeccakF-1600.o asm_chacha.o


all: client.bin server.bin speed.bin memsize.bin


client.elf: client.o $(OBJS) $(LDSCRIPT) libopencm3_stm32f0.a
	$(LD) -o client.elf client.o $(OBJS) $(LDFLAGS) libopencm3_stm32f0.a


server.elf: server.o $(OBJS) $(LDSCRIPT) libopencm3_stm32f0.a
	$(LD) -o server.elf server.o $(OBJS) $(LDFLAGS) libopencm3_stm32f0.a


speed.elf: $(STMOBJ) $(OBJS) speed.o print.o
	$(LD) $(CFLAGS) $(INCDIRS) -T $(LINKERFILE) $(STMOBJ) $(OBJS) print.o speed.o  -o $@

memsize.elf: $(STMOBJ) $(OBJS) memsize.o print.o
	$(LD) $(CFLAGS) $(INCDIRS) -T $(LINKERFILE) $(STMOBJ) $(OBJS) print.o memsize.o  -o $@

%.bin: %.elf
	$(OBJCOPY)   -O binary $^ $@

%.o: %.s
	$(LD) $(CFLAGS) -c $^ -o $@

%.o: %.c
	$(LD) $(CFLAGS) -o $@ -c $<

clean:
	find . -name \*.o -type f -exec rm -f {} \;
	find . -name \*.d -type f -exec rm -f {} \;
	rm -f *.elf
	rm -f *.bin
