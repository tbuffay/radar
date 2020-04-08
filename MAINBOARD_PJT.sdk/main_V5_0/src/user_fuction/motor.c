/*
 * motor.c
 *
 *  Created on: 2018Äê11ÔÂ29ÈÕ
 *      Author: Administrator
 */

#include "motor.h"
#include "xil_io.h"
#include "math.h"

/********************************************************
 *
 *
 *******************************************************/
void MotorInit(void){

	MotorParameterInst.correct_reference_code= (u8)30;
	MotorParameterInst.correct_angle_code	 = (u16)60;

	Xil_Out32(MOTOR_BASEADDR + 4,MotorParameterInst.correct_reference_code&0x000000ff);
	Xil_Out32(MOTOR_BASEADDR + 8,MotorParameterInst.correct_angle_code&0x0000ffff);
}
/********************************************************
 *
 *
 *******************************************************/
void SetMotorSpeed(u16 speed){
	u32 data;
	data = speed*100;
	Xil_Out32(MOTOR_BASEADDR,data);

}
/********************************************************
 *
 *
 *
 *******************************************************/
void GetMotorState(void){
	MotorStateInst.measure_angle =  Xil_In32(MOTOR_BASEADDR+4*8);
	MotorStateInst.measure_speed =  Xil_In32(MOTOR_BASEADDR+4*9);
}
/******************************************************/
/*end*/
