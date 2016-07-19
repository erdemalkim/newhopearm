#include <stdint.h>
#include <rcc.h>
#include <gpio.h>
#include <usart.h>
#include <nvic.h>
#include <dma.h>
#include <rng.h>
#include "stm32f4_wrapper.h"
#include "poly.h"

int done_flag = 1;



void clock_setup(void)
{
	rcc_clock_setup_hse_3v3(&hse_8mhz_3v3[CLOCK_3V3_48MHZ]);
	rcc_periph_clock_enable(RCC_GPIOD);
    rcc_periph_clock_enable(RCC_GPIOA);
    rcc_periph_clock_enable(RCC_USART2);
    rcc_periph_clock_enable(RCC_DMA1);
	rcc_periph_clock_enable(RCC_RNG);
}

void gpio_setup(void)
{
    gpio_mode_setup(GPIOA, GPIO_MODE_AF, GPIO_PUPD_NONE, GPIO2 | GPIO3);
    gpio_set_af(GPIOA, GPIO_AF7, GPIO2 | GPIO3);
	gpio_mode_setup(GPIOD, GPIO_MODE_OUTPUT,GPIO_PUPD_NONE, GPIO12);
}

void usart_setup(int baud)
{
    usart_set_baudrate(USART2, baud);
    usart_set_databits(USART2, 8);
    usart_set_stopbits(USART2, USART_STOPBITS_1);
    usart_set_mode(USART2, USART_MODE_TX_RX);
    usart_set_parity(USART2, USART_PARITY_NONE);
    usart_set_flow_control(USART2, USART_FLOWCONTROL_NONE);

    usart_enable(USART2);
	gpio_set(GPIOD, GPIO12);
}

void rng_setup(void)
{
	RNG_CR |= RNG_CR_IE;
	RNG_CR |= RNG_CR_RNGEN;
}

void dma_request_setup(void)
{
    dma_stream_reset(DMA1, DMA_STREAM6);

    nvic_enable_irq(NVIC_DMA1_STREAM6_IRQ);

    dma_set_peripheral_address(DMA1, DMA_STREAM6, (uint32_t) &USART2_DR);
    dma_set_transfer_mode(DMA1, DMA_STREAM6, DMA_SxCR_DIR_PERIPHERAL_TO_MEM);

    dma_set_peripheral_size(DMA1, DMA_STREAM6, DMA_SxCR_PSIZE_8BIT);
    dma_set_memory_size(DMA1, DMA_STREAM6, DMA_SxCR_MSIZE_8BIT);

    dma_set_priority(DMA1, DMA_STREAM6, DMA_SxCR_PL_VERY_HIGH);

    dma_disable_peripheral_increment_mode(DMA1, DMA_SxCR_CHSEL_4);
    dma_enable_memory_increment_mode(DMA1, DMA_STREAM6);

    dma_disable_transfer_error_interrupt(DMA1, DMA_STREAM6);
    dma_disable_half_transfer_interrupt(DMA1, DMA_STREAM6);
    dma_disable_direct_mode_error_interrupt(DMA1, DMA_STREAM6);
    dma_disable_fifo_error_interrupt(DMA1, DMA_STREAM6);
    dma_enable_transfer_complete_interrupt(DMA1, DMA_STREAM6);

    usart_enable_rx_dma(USART2);
}

void dma_transmit_setup(void)
{
    dma_stream_reset(DMA1, DMA_STREAM7);

    nvic_enable_irq(NVIC_DMA1_STREAM7_IRQ);

    dma_set_peripheral_address(DMA1, DMA_STREAM7, (uint32_t) &USART2_DR);
    dma_set_transfer_mode(DMA1, DMA_STREAM7, DMA_SxCR_DIR_MEM_TO_PERIPHERAL);

    dma_set_peripheral_size(DMA1, DMA_STREAM7, DMA_SxCR_PSIZE_8BIT);
    dma_set_memory_size(DMA1, DMA_STREAM7, DMA_SxCR_MSIZE_8BIT);

    dma_set_priority(DMA1, DMA_STREAM7, DMA_SxCR_PL_VERY_HIGH);

    dma_disable_peripheral_increment_mode(DMA1, DMA_SxCR_CHSEL_4);
    dma_enable_memory_increment_mode(DMA1, DMA_STREAM7);

    dma_disable_transfer_error_interrupt(DMA1, DMA_STREAM7);
    dma_disable_half_transfer_interrupt(DMA1, DMA_STREAM7);
    dma_disable_direct_mode_error_interrupt(DMA1, DMA_STREAM7);
    dma_disable_fifo_error_interrupt(DMA1, DMA_STREAM7);
    dma_enable_transfer_complete_interrupt(DMA1, DMA_STREAM7);

    usart_enable_tx_dma(USART2);
}

void dma_request(void* buffer, const int datasize)
{
    done_flag = 0;

    dma_set_memory_address(DMA1, DMA_STREAM6, (uint32_t) buffer);
    dma_set_number_of_data(DMA1, DMA_STREAM6, datasize);

    dma_channel_select(DMA1, DMA_STREAM6, DMA_SxCR_CHSEL_4);
    dma_enable_stream(DMA1, DMA_STREAM6);
}

void dma_transmit(const void* buffer, const int datasize)
{

    dma_set_memory_address(DMA1, DMA_STREAM7, (uint32_t) buffer);
    dma_set_number_of_data(DMA1, DMA_STREAM7, datasize);

    dma_channel_select(DMA1, DMA_STREAM7, DMA_SxCR_CHSEL_4);
    dma_enable_stream(DMA1, DMA_STREAM7);
}


void send_USART_str(const unsigned char* in)
{
    		gpio_toggle(GPIOD, GPIO12);
	int i;
    for(i = 0; in[i] != 0; i++) {
		usart_send_blocking(USART2, in[i]);
    }
    
	usart_send_blocking(USART2, '\r');
    usart_send_blocking(USART2, '\n');
}
void send_USART_carr(const unsigned char* in)
{
    		gpio_toggle(GPIOD, GPIO12);
	int i;
    for(i = 0; in[i] != 0; i++) {
		usart_send_blocking(USART2, in[i]);
    }
}
void send_USART_bytes(const unsigned char* in, int n)
{
    int i;
    for(i = 0; i < n; i++) {
        usart_send_blocking(USART2, in[i]);
    }
		gpio_toggle(GPIOD, GPIO12);
}

void recv_USART_bytes(unsigned char* out, int n)
{
    int i;
    for(i = 0; i < n; i++) {
        out[i] = usart_recv_blocking(USART2);
    }
}

void dma1_stream6_isr(void) {
    dma_clear_interrupt_flags(DMA1, DMA_STREAM6, DMA_TCIF);
    dma_disable_stream(DMA1, DMA_STREAM6);
}

void dma1_stream7_isr(void) {
    dma_clear_interrupt_flags(DMA1, DMA_STREAM7, DMA_TCIF);
    dma_disable_stream(DMA1, DMA_STREAM7);
}

void signal_host(void) {
    usart_send_blocking(USART2, (char)4);
}

void random_int(uint32_t* urnd, int n)
{
	unsigned int last_value=0;
	unsigned int new_value=0;
	int i;
	unsigned int error_bits = 0;
	for(i=0;i<n;i++)
	{
	error_bits = RNG_SR_SEIS | RNG_SR_CEIS;
	while (new_value == last_value) {
		if (((RNG_SR & error_bits) == 0) &&
		    ((RNG_SR & RNG_SR_DRDY) == 1)) {
			new_value = RNG_DR;
		}
	}
	last_value = new_value;
	urnd[i] = new_value;
	}
}
void poly_getnoise_fast(poly *r, unsigned char *seed, unsigned char nonce)
{ 

	unsigned int last_value=0;
	unsigned int new_value=0;
	uint32_t i,j,d,a,b;
	unsigned int error_bits = 0;
	for(i=0;i<PARAM_N;i++)
	{
	error_bits = RNG_SR_SEIS | RNG_SR_CEIS;
	while (new_value == last_value) {
		if (((RNG_SR & error_bits) == 0) &&
		    ((RNG_SR & RNG_SR_DRDY) == 1)) {
			new_value = RNG_DR;
		}
	}
	last_value = new_value;
    d = 0;
    for(j=0;j<8;j++)
      d += (new_value >> j) & 0x01010101;
    a = ((d >> 8) & 0xff) + (d & 0xff);
    b = (d >> 24) + ((d >> 16) & 0xff);
    r->v[i] = a + PARAM_Q - b;

	}
}
