/*
 * ps_gpio_control.h
 *
 *  Created on: 2020Äê3ÔÂ20ÈÕ
 *      Author: ThinKpad
 */

#ifndef SRC_USER_FUCTION_PS_GPIO_CONTROL_H_
#define SRC_USER_FUCTION_PS_GPIO_CONTROL_H_

#include "xgpiops.h"

#define PS_GPIO_ID XPAR_XGPIOPS_0_DEVICE_ID
/*out*/
#define PS_LED_PIN	32

XGpioPs PsGpioInst;

void PsGpioInit(void);

#define PsLedOn() XGpioPs_WritePin(&PsGpioInst, PS_LED_PIN, 0)
#define PsLedOff() XGpioPs_WritePin(&PsGpioInst, PS_LED_PIN, 1)

#endif /* SRC_USER_FUCTION_PS_GPIO_CONTROL_H_ */
