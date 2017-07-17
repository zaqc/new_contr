/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>

#include "FreeRTOSConfig.h"
#include "FreeRTOS.h"
#include "task.h"

#include "system.h"
#include "altera_avalon_timer.h"
#include "altera_avalon_timer_regs.h"
#include "altera_avalon_pio_regs.h"
//#include "priv/alt_legacy_irq.h"
#include "altera_nios2_qsys_irq.h"
#include "sys/alt_irq.h"
//----------------------------------------------------------------------------

unsigned char self_mac_addr[6] = { 0x00, 0x23, 0x54, 0x3C, 0x47, 0x1B };
unsigned char self_ip_addr[4] = { 10, 0, 0, 100 };

#define SEND_SRC_MAC_ADDR_1		0x03
#define SEND_SRC_MAC_ADDR_2		0x04
#define SEND_DST_MAC_ADDR_1		0x05
#define SEND_DST_MAC_ADDR_2		0x06
#define SEND_SRC_IP_ADDR		0x07
#define SEND_DST_IP_ADDR		0x08
#define SEND_SRC_PORT			0x09
#define SEND_DST_PORT			0x0A
#define SEND_SRC_DST_PORT		0x0B
#define SEND_UDP_DATA_LEN		0x0C

#define	SEND_ARP_OPERATION		0x0D
#define SEND_ARP_DST_MAC_ADDR_1	0x0E
#define SEND_ARP_DST_MAC_ADDR_2	0x0F
#define SEND_ARP_DST_IP			0x10
#define SEND_ARP_SRC_MAC_ADDR_1	0x11
#define SEND_ARP_SRC_MAC_ADDR_2	0x12
#define SEND_ARP_SRC_IP			0x13
//----------------------------------------------------------------------------

#define	RECV_DST_MAC_ADDR1		(0x01 * 0x04)
#define	RECV_DST_MAC_ADDR2		(0x02 * 0x04)
#define	RECV_SRC_MAC_ADDR1		(0x03 * 0x04)
#define	RECV_SRC_MAC_ADDR2		(0x04 * 0x04)
#define	RECV_ARP_SHA1			(0x05 * 0x04)
#define	RECV_ARP_SHA2			(0x06 * 0x04)
#define	RECV_ARP_SPA			(0x07 * 0x04)
#define	RECV_ARP_THA1			(0x08 * 0x04)
#define	RECV_ARP_THA2			(0x09 * 0x04)
#define	RECV_ARP_TPA			(0x0A * 0x04)
#define	RECV_PKT_TYPE			(0x0B * 0x04)
//----------------------------------------------------------------------------

void thread1(void *param) {
	while (1) {
		vTaskDelay(750);
		//printf("one ");
	}
}
//----------------------------------------------------------------------------

void thread2(void *param) {
	while (1) {
		int i = 0;
		while (1) {
			if (i == 0) {
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_MAC_ADDR_1, 0xFFFFFFFF);
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_MAC_ADDR_2, 0xFFFFFFFF);

				//{0x00, 0x23, 0x54, 0x3C, 0x47, 0x1B};
				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_MAC_ADDR_1, 0x0023543C);
				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_MAC_ADDR_2, 0xFFFF471B);

				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_OPERATION, 1);
				// arp request DST_MAC

				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_DST_MAC_ADDR_1, 0xFFFFFFFF);
				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_DST_MAC_ADDR_2, 0xFFFFFFFF);
				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_DST_IP, 0x0A000002);

				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_SRC_MAC_ADDR_1, 0x0023543C);
				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_SRC_MAC_ADDR_2, 0xFFFF471B);
				IOWR(MAC_CTRL_TX_BASE, SEND_ARP_SRC_IP, 0x0A000064);
				i = 1;
			} else {
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_MAC_ADDR_1, 0x0c54a531);
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_MAC_ADDR_2, 0xFFFF2485);
				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_MAC_ADDR_1, 0x0023543c);
				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_MAC_ADDR_2, 0xFFFF471b);

				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_IP_ADDR, 0x0A000064);
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_IP_ADDR, 0x0A000002);
				IOWR(MAC_CTRL_TX_BASE, SEND_SRC_PORT, 0xFFFF5152);
				IOWR(MAC_CTRL_TX_BASE, SEND_DST_PORT, 0xFFFF2179);
				IOWR(MAC_CTRL_TX_BASE, SEND_UDP_DATA_LEN, 0xFFFF0400);

				i = 0;
			}

			//IOWR(MAC_CTRL_0_BASE, 2, 0xFFFFFFFF);

			IOWR(MAC_CTRL_TX_BASE, 2, (i == 0) ? 2 : 1);

			// vTaskDelay(1000);

//			i++;
//			IOWR(MAC_CTRL_TX_BASE, 1, i);

			//printf("two ");
			volatile uint32_t v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x38);
			v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x14);
			v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x08);
			v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x2C);
			v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x14);

			vTaskDelay(500);
		}
	}
}
//----------------------------------------------------------------------------
#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void mac_irq(void* context)
#else
static void mac_irq(void* context, alt_u32 id)
#endif
{
//	printf("MAC IRQ rise...\n");
	__asm("nop");
}

#ifdef ALT_ENHANCED_INTERRUPT_API_PRESENT
static void pio_irq(void* context)
#else
static void pio_irq(void* context, alt_u32 id)
#endif
{
//	printf("MAC IRQ rise...\n");
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_INT_BASE, 0);

	volatile uint32_t v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_SRC_MAC_ADDR1);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_SRC_MAC_ADDR2);

	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_DST_MAC_ADDR1);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_DST_MAC_ADDR2);

	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_ARP_SPA);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, RECV_ARP_TPA);

	__asm("nop");
}

int main() {

//	alt_ic_isr_register(SYS_CLK_IRQ_INTERRUPT_CONTROLLER_ID, SYS_CLK_IRQ,
//			&mac_irq, NULL, 0);
//	alt_ic_irq_enable(SYS_CLK_IRQ_INTERRUPT_CONTROLLER_ID, SYS_CLK_IRQ);

////	alt_ic_isr_register(0, 2, &mac_irq, NULL, 0);
////	alt_ic_irq_enable(0, 2);
////
	alt_ic_isr_register(0, 3, &pio_irq, NULL, 0);
	alt_ic_irq_enable(0, 3);

	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_INT_BASE, 0xFFFFFFFF);

	volatile uint32_t v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x04);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x08);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x0C);
	v = IORD_32DIRECT(MAC_CTRL_RX_BASE, 0x10);

	//portENABLE_INTERRUPTS();

	printf("Program started...\n");

	__asm("nop");

//	int i = 0;
//	while (1) {
//		IOWR(MAC_CTRL_BASE, DST_MAC_ADDR_1, 0xFFFFFFFF);
//		IOWR(MAC_CTRL_BASE, DST_MAC_ADDR_2, 0xFFFFFFFF);
//
//		//{0x00, 0x23, 0x54, 0x3C, 0x47, 0x1B};
//		IOWR(MAC_CTRL_BASE, SRC_MAC_ADDR_1, 0x0023543C);
//		IOWR(MAC_CTRL_BASE, SRC_MAC_ADDR_2, 0xFFFF471B);
//
//		IOWR(MAC_CTRL_BASE, ARP_OPERATION, 1);
//		// arp request DST_MAC
//
//		IOWR(MAC_CTRL_BASE, ARP_DST_MAC_ADDR_1, 0xFFFFFFFF);
//		IOWR(MAC_CTRL_BASE, ARP_DST_MAC_ADDR_2, 0xFFFFFFFF);
//		IOWR(MAC_CTRL_BASE, ARP_DST_IP, 0x0A000002);
//
//		IOWR(MAC_CTRL_BASE, ARP_SRC_MAC_ADDR_1, 0x0023543C);
//		IOWR(MAC_CTRL_BASE, ARP_SRC_MAC_ADDR_2, 0xFFFF471B);
//		IOWR(MAC_CTRL_BASE, ARP_SRC_IP, 0x0A000064);
//
//		//IOWR(MAC_CTRL_0_BASE, 2, 0xFFFFFFFF);
//
//		IOWR(MAC_CTRL_BASE, 2, 1);
//
//		int n = 0;
//		//int k = 0;
//		for (n = 0; n < 1000000; n++)
//			;
//
//		i++;
//		IOWR(MAC_CTRL_BASE, 1, i);
//	}

//vTaskEndScheduler();
//printf("Hello from Nios II!\n");

	TaskHandle_t h_thread1;
	xTaskCreate(&thread1, "thread one", configMINIMAL_STACK_SIZE, NULL,
			tskIDLE_PRIORITY, &h_thread1);

	TaskHandle_t h_thread2;
	xTaskCreate(&thread2, "thread two", configMINIMAL_STACK_SIZE, NULL,
			tskIDLE_PRIORITY, &h_thread2);

//	char str[16];
//	sprintf("0x%08X \r\n", (unsigned int)h_thread);
//	printf(str);

	vTaskStartScheduler();

	thread2(NULL);

	while (1) {
	}

	return 0;
}
//----------------------------------------------------------------------------

void vApplicationStackOverflowHook(void) {
	/* Look at pxCurrentTCB to see which task overflowed its stack. */
	while (1) {
		//asm( "break" );
	}
}
/*-----------------------------------------------------------*/
