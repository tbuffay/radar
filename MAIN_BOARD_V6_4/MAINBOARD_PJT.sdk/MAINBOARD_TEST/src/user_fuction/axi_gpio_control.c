/*
 * axi_gpio_control.c
 *
 *  Created on: 2018Äê12ÔÂ12ÈÕ
 *      Author: Administrator
 */

#include "axi_gpio_control.h"

void AxiGpioInit(void){

	XGpio_Initialize(&AxiGpioInst, AXI_GPIO_ID);
	XGpio_SetDataDirection(&AxiGpioInst, AXI_GPIO_OUT_CHANNEL,  0x00000000);
	XGpio_SetDataDirection(&AxiGpioInst, AXI_GPIO_IN_CHANNEL, 0xffffffff);
	XGpio_DiscreteClear(&AxiGpioInst, AXI_GPIO_OUT_CHANNEL, 0xffffffff);
}


