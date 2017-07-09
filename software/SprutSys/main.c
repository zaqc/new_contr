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

#define SRC_MAC_ADDR_1		10
#define SRC_MAC_ADDR_2		11
#define DST_MAC_ADDR_1		12
#define DST_MAC_ADDR_2		13
#define SRC_IP_ADDR			14
#define DST_IP_ADDR			15
#define SRC_PORT			16
#define DST_PORT			17
#define SRC_DST_PORT		18

#define	ARP_OPERATION		19
#define ARP_DST_MAC_ADDR_1	20
#define ARP_DST_MAC_ADDR_2	21
#define ARP_DST_IP			22
#define ARP_SRC_MAC_ADDR_1	23
#define ARP_SRC_MAC_ADDR_2	24
#define ARP_SRC_IP			25
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
			IOWR(MAC_CTRL_TX_BASE, DST_MAC_ADDR_1, 0xFFFFFFFF);
			IOWR(MAC_CTRL_TX_BASE, DST_MAC_ADDR_2, 0xFFFFFFFF);

			//{0x00, 0x23, 0x54, 0x3C, 0x47, 0x1B};
			IOWR(MAC_CTRL_TX_BASE, SRC_MAC_ADDR_1, 0x0023543C);
			IOWR(MAC_CTRL_TX_BASE, SRC_MAC_ADDR_2, 0xFFFF471B);

			IOWR(MAC_CTRL_TX_BASE, ARP_OPERATION, 1);
			// arp request DST_MAC

			IOWR(MAC_CTRL_TX_BASE, ARP_DST_MAC_ADDR_1, 0xFFFFFFFF);
			IOWR(MAC_CTRL_TX_BASE, ARP_DST_MAC_ADDR_2, 0xFFFFFFFF);
			IOWR(MAC_CTRL_TX_BASE, ARP_DST_IP, 0x0A000002);

			IOWR(MAC_CTRL_TX_BASE, ARP_SRC_MAC_ADDR_1, 0x0023543C);
			IOWR(MAC_CTRL_TX_BASE, ARP_SRC_MAC_ADDR_2, 0xFFFF471B);
			IOWR(MAC_CTRL_TX_BASE, ARP_SRC_IP, 0x0A000064);

			//IOWR(MAC_CTRL_0_BASE, 2, 0xFFFFFFFF);

			IOWR(MAC_CTRL_TX_BASE, 2, 1);

			vTaskDelay(1000);

			i++;
			IOWR(MAC_CTRL_TX_BASE, 1, i);

			//printf("two ");
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
	IORD_ALTERA_AVALON_PIO_DATA(PIO_INT_BASE);
	IORD_ALTERA_AVALON_PIO_DATA(PIO_INT_BASE);
	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PIO_INT_BASE, 0);
	__asm("nop");
}

int main() {

//	alt_ic_isr_register(MAC_CTRL_IRQ_INTERRUPT_CONTROLLER_ID, MAC_CTRL_IRQ,
//			&mac_irq, NULL, 0);
//	alt_ic_irq_enable(MAC_CTRL_IRQ_INTERRUPT_CONTROLLER_ID, MAC_CTRL_IRQ);

//	alt_ic_isr_register(PIO_INT_IRQ_INTERRUPT_CONTROLLER_ID, PIO_INT_IRQ,
//			&pio_irq, NULL, 0);
//	alt_ic_irq_enable(PIO_INT_IRQ_INTERRUPT_CONTROLLER_ID, PIO_INT_IRQ);

	alt_ic_isr_register(0, 3, &pio_irq, NULL, 0);
	alt_ic_irq_enable(0, 3);

	IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PIO_INT_BASE, 0xFFFFFFFF);

	portENABLE_INTERRUPTS();

	//printf("Program started...\n");

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
