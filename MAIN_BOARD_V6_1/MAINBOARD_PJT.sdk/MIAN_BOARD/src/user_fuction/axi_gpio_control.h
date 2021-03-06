/*
 * axi_gpio_control.h
 *
 *  Created on: 2018��12��12��
 *      Author: Administrator
 */

#ifndef SRC_AXI_GPIO_CONTROL_H_
#define SRC_AXI_GPIO_CONTROL_H_

#include "xgpio.h"

#define AXI_GPIO_ID XPAR_GPIO_0_DEVICE_ID
#define AXI_GPIO_IN_CHANNEL 2
#define AXI_GPIO_OUT_CHANNEL 1
/*out*/
#define POWER_TOP_BIT	0x1
#define MOTOR_EN_BIT	0x2
#define IPT_CLEAR_BIT	0x4
#define MOTOR_OPLOP  	0x8
#define SOLID_FLASH		0x10
#define DEBUG_ROTOR		0x20
/*out*/
#define ROTOR_DIRECTION	0x1

XGpio XGpioInst;

void GpioInit(void);

#define TopPowerOn() XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_TOP_BIT)
#define TopPowerOff() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, POWER_TOP_BIT)
#define MotorEn()  XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_EN_BIT)
#define MotorShut() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_EN_BIT)
#define IptClearSet() XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, IPT_CLEAR_BIT)
#define IptClearSetClear() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, IPT_CLEAR_BIT)
#define MotorOplopEn() XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_OPLOP)
#define MotorOplopShut() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, MOTOR_OPLOP)
#define SolidRotorParamEn() XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, SOLID_FLASH)
#define SolidRotorParamShut() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, SOLID_FLASH)
#define DebugRotorEn() XGpio_DiscreteSet(&XGpioInst, AXI_GPIO_OUT_CHANNEL, DEBUG_ROTOR)
#define DebugRotorShut() XGpio_DiscreteClear(&XGpioInst, AXI_GPIO_OUT_CHANNEL, DEBUG_ROTOR)

#define AxiGetGpioState() XGpio_DiscreteRead(&XGpioInst, AXI_GPIO_IN_CHANNEL)



#endif /* SRC_AXI_GPIO_CONTROL_H_ */
