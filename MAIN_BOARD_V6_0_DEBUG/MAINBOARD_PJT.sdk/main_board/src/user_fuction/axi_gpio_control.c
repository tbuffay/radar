/*
 * axi_gpio_control.c
 *
 *  Created on: 2018Äê12ÔÂ12ÈÕ
 *      Author: Administrator
 */

#include "axi_gpio_control.h"

void GpioInit(void){

	XGpio_Initialize(&XGpioInst, AXI_GPIO_ID);
	XGpio_SetDataDirection(&XGpioInst, AXI_GPIO_OUT_CHANNEL,  0x00000000);
	XGpio_SetDataDirection(&XGpioInst, AXI_GPIO_IN_CHANNEL, 0xffffffff);
	XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, 0xffffffff);
}


