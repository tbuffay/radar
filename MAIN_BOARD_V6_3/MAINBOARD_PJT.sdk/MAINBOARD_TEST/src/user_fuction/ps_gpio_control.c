/*
 * ps_gpio_control.c
 *
 *  Created on: 2020Äê3ÔÂ20ÈÕ
 *      Author: ThinKpad
 */

#include "ps_gpio_control.h"

void PsGpioInit(void){
	XGpioPs_Config *XGpioPs_ConfigPtr;
	int Status;
	XGpioPs_ConfigPtr=XGpioPs_LookupConfig(PS_GPIO_ID);
	Status=XGpioPs_CfgInitialize(&PsGpioInst, XGpioPs_ConfigPtr,XGpioPs_ConfigPtr->BaseAddr);
	if(Status!=XST_SUCCESS){
		return XST_FAILURE;
	}
	XGpioPs_SetDirectionPin(&PsGpioInst, PS_LED_PIN,  1);
	XGpioPs_SetOutputEnablePin(&PsGpioInst, PS_LED_PIN, 1);
}

