/*
 * motor.h
 *
 *  Created on: 2018Äê11ÔÂ29ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_MOTOR_H_
#define SRC_MOTOR_H_

#include "xstatus.h"

/********************************************************
 * motor
 *
 *
 *******************************************************/
/***************************************************
    ***MOTOR_BASEADDR		:set_speed    			-> BIT15~0
    ***MOTOR_BASEADDR+4*1	:correct_reference_code	-> BIT 7~0
    ***MOTOR_BASEADDR+4*2	:correct_angle_code		-> BIT15~0
    ***MOTOR_BASEADDR+4*8	:measure_angle			-> BIT31~16
    ***MOTOR_BASEADDR+4*9	:measure_speed			-> BIT15~0
    *************************************************/

#define MOTOR_BASEADDR XPAR_YF_AXI_LITE_PERIPHERAL_0_S00_AXI_BASEADDR

typedef struct {
	u8	correct_reference_code;
	u16	correct_angle_code;
} MotorParameter_t;

typedef struct {
	u32 measure_speed;
	u32 measure_angle;
} MotorState_t;


MotorParameter_t MotorParameterInst;
MotorState_t MotorStateInst;

void MotorInit(void);
void SetMotorSpeed(u16 speed);
void GetMotorState(void);

#endif /* SRC_MOTOR_H_ */
