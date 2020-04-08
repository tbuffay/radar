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
 *
 *******************************************************/
void GetMotorState(void){
	MotorStateInst.speed =  Xil_In32(MOTOR_BASEADDR+4*8)/10.0;
	MotorStateInst.angle =  Xil_In32(MOTOR_BASEADDR+4*9)/100.0;
	MotorStateInst.voltage =  (Xil_In32(MOTOR_BASEADDR+4*10)&0x0000ffff)/1000.0;
	MotorStateInst.current = ((Xil_In32(MOTOR_BASEADDR+4*10)&0xffff0000)>>16)/10.0;
	MotorStateInst.direction =  AxiGetGpioState()&0x000000ff;
}
/********************************************************
 *
 *
 *******************************************************/
void SetMotorSpeed(void){
	Xil_Out32(MOTOR_BASEADDR,(u32)(MotorParameterInst.set_speed*10));
}
/********************************************************
 *
 *
 *
 *******************************************************/
void SetMotorOParameter(void){
	Xil_Out32(MOTOR_BASEADDR+4*4,(u32)(MotorParameterInst.dead_zone<<16)|
									MotorParameterInst.adcance_angle);
}
/********************************************************
 *
 *
 *
 *******************************************************/
void SetMotorParameter(void){
	Xil_Out32(MOTOR_BASEADDR+4*1,(u32)MotorParameterInst.ar_period*100000);
	Xil_Out32(MOTOR_BASEADDR+4*2,(u32)(MotorParameterInst.asr_kp<<16)|
									MotorParameterInst.asr_ki);
	Xil_Out32(MOTOR_BASEADDR+4*3,(u32)(MotorParameterInst.acr_kp<<16)|
									MotorParameterInst.acr_ki);
}
/********************************************************
 *
 *
 *
 *******************************************************/
void Delay(u16 cnt){
	u16 i;
	for(i=0;i<cnt;i++);
}
/******************************************************/
/*end*/
