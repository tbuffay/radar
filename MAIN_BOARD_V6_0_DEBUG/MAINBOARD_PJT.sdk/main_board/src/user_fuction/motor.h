/*
 * motor.h
 *
 *  Created on: 2018Äê11ÔÂ29ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_MOTOR_H_
#define SRC_MOTOR_H_

#include "xstatus.h"
#include "axi_gpio_control.h"

/********************************************************
 * motor
 *
 *
 ******************************************************/
/***************************************************
    ***MOTOR_BASEADDR		:set_speed 		->
    ***MOTOR_BASEADDR+4*1	:ar_period		->
    ***MOTOR_BASEADDR+4*2	:asr_kp			-> BIT32~16
    						:asr_ki			-> BIT15~0
    ***MOTOR_BASEADDR+4*3	:acr_kp			-> BIT32~16
    						:acr_ki			-> BIT15~0
    ***MOTOR_BASEADDR+4*4	:dead_zone		-> BIT24~16
   							:adcance_angle	-> BIT15~0
	***************************************************
    ***MOTOR_BASEADDR+4*8	:speed			->
    ***MOTOR_BASEADDR+4*9	:angle			->
    ***MOTOR_BASEADDR+4*10	:current		-> BIT32~16
    						:voltage		-> BIT15~0
    *************************************************/

#define MOTOR_BASEADDR XPAR_YF_AXI_LITE_MOTOR_S00_AXI_BASEADDR

typedef struct {
	u32 set_speed;
	u32 ar_period;
	u16 asr_kp;
	u16 asr_ki;
	u16 acr_kp;
	u16 acr_ki;
	u16 adcance_angle;
	u16	dead_zone;
} MotorParameter_t;

typedef struct {
	u8	direction;
	float current;
	float voltage;
	float speed;
	float angle;
} MotorState_t;

MotorParameter_t MotorParameterInst;
MotorState_t MotorStateInst;

void SetMotorSpeed(void);
void SetMotorParameter(void);
void SetMotorOParameter(void);
void GetMotorState(void);
void Delay(u16 cnt);

#endif /* SRC_MOTOR_H_ */
