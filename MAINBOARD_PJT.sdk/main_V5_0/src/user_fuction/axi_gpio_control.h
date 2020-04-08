/*
 * axi_gpio_control.h
 *
 *  Created on: 2018Äê12ÔÂ12ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_AXI_GPIO_CONTROL_H_
#define SRC_AXI_GPIO_CONTROL_H_

#include "xgpio.h"

#define AXI_GPIO_ID XPAR_GPIO_0_DEVICE_ID
#define AXI_GPIO_IN_CHANNEL 1
#define AXI_GPIO_OUT_CHANNEL 2

//#define POWER_5V_BIT  0x1
#define POWER_TOP_BIT 0x1
#define MOTOR_EN_BIT  0x2
#define IPT_CLEAR_BIT  0x4


XGpio XGpioInst;

void GpioInit(void);

//#define Vcc5PowerOn()  XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_5V_BIT)
//#define Vcc5PowerOff() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_5V_BIT)
#define TopPowerOn()   XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_TOP_BIT)
#define TopPowerOff()  XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_TOP_BIT)
#define AxiGetGpioState() XGpio_DiscreteRead(&XGpioInst, AXI_GPIO_IN_CHANNEL)
#define MotorEn()      XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_EN_BIT)
#define MotorShut()    XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_EN_BIT)
#define IptClearSet()    XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, IPT_CLEAR_BIT)
#define IptClearSetClear()    XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, IPT_CLEAR_BIT)



#endif /* SRC_AXI_GPIO_CONTROL_H_ */
