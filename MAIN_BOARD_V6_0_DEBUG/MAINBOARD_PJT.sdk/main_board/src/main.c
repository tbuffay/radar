/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * main.c: simple test application
 *
 * This application configures UART 16550 to baud rate 10000.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   10000
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include "user_fuction\user_fuction.h"

volatile u32 Isqflag,UartRevflag;
volatile u32 ReceivedByteNum;

u32 SpeedAry[200000];
u16 AngleLast,Angle;
u32 Speed;
u16 AngleAry[200000];

/**************************************************************************/
int main()
{
	/**********************************/
	u16 UiOrder=0;
	//u32 UiOrderFlag=0;
	//u16	TopSpeed=0;
	//u8 TopMotorEn=0;
	AngleLast=0;

	//u16*TopSpeed_p=(u16*)(0x40000000+0x54e);
	Isqflag=0;
	UartRevflag=0;
	ReceivedByteNum=0;
	u32 SendByteNum=0;
	u8 UiOrderArray[16];
	u32 data;
	float fdata=0.0;
	float fdata1=0.0;
	/**********************************/
	GpioInit();
	UartPsInt();

	MotorShut();
	MotorOplopShut();
	DebugRotorShut();

	//SetMotorSpeed( (u16)300);
	InterruptInitial();
	/**********************************/
//	MotorEn();
//	sleep(5);
//	TopPowerOn();
	XScuGic_Enable(&myXScuGic, DATA_PACKET_IRQ_ID);
	XScuGic_Enable(&myXScuGic, UART_INT_IRQ_ID);
/******************************************************************///test with_uart
///*
	while(1){

		if(UartRevflag){
			UartRevflag=0;
			RecvBufferPtr = RecvBuffer;
			SendByteNum = ReceivedByteNum ;
			ReceivedByteNum = 0 ;
			memset(UiOrderArray,0x00,sizeof(UiOrderArray)) ;
			memcpy(UiOrderArray,RecvBuffer,SendByteNum) ;
			UartPsSend(UiOrderArray, SendByteNum);
			if(UiOrderArray[0]==0xfa && UiOrderArray[17]==0xbe ){
				switch(UiOrderArray[1]){
					case 0x00:{						//��������
						DebugRotorShut();
						MotorOplopShut();
						break;
					}
					case 0x01:{						//����
						DebugRotorEn();
						if(UiOrderArray[16]==1){
							SolidRotorParamEn();
							SolidRotorParamShut();
						}
						else{
							if(UiOrderArray[3]==1){//��������������ʱ��ͳ�ǰ��
								MotorOplopEn();
								MotorParameterInst.set_speed=(u32)(UiOrderArray[4]<<8 | UiOrderArray[5]);
								MotorParameterInst.adcance_angle=(u16)(UiOrderArray[7]<<8|UiOrderArray[8]);
								MotorParameterInst.dead_zone=(u16)UiOrderArray[6];
								SetMotorSpeed();
								SetMotorOParameter();
							}
							else{//�ջ�������PI����
								MotorOplopShut();
								MotorParameterInst.set_speed=(u32)(UiOrderArray[4]<<8 | UiOrderArray[5]);
								MotorParameterInst.ar_period=(u32)(UiOrderArray[6]<<8|UiOrderArray[7]);
								MotorParameterInst.asr_kp=(u16)UiOrderArray[8]<<8|UiOrderArray[9];
								MotorParameterInst.asr_ki=(u16)UiOrderArray[10]<<8|UiOrderArray[11];
								MotorParameterInst.acr_kp=(u16)UiOrderArray[12]<<8|UiOrderArray[13];
								MotorParameterInst.acr_ki=(u16)UiOrderArray[14]<<8|UiOrderArray[15];
								SetMotorSpeed();
								SetMotorParameter();
							}
						}
						break;
					}
					default:break;
				}
				if(UiOrderArray[2]==1){	MotorEn();}
				else {MotorShut();}
			}
		}
//*/
/******************************************************************///debug motor
//*
		GetMotorState();
		printf( "%.2f %.2f %.2f \n"
				,MotorStateInst.speed
				,MotorStateInst.angle
				,MotorStateInst.current
		);
//*/
/******************************************************************///monitor power
/*
		Monitor();
		printf( "MonitorInst.top_monitor.temp: %.2f\n"
				"MonitorInst.top_monitor.sample_hv: %.2f\n"
				""
				,MotorStateInst.voltage
				,MotorStateInst.current
		);
//*/
/******************************************************************///test encoders
/*
		GetMotorState();
		fdata1=fdata;
		fdata=MotorStateInst.angle;
		if(fdata!=fdata1){
			printf( "%.2f \n",fdata);
		}
//*/
/******************************************************************/
	}
	return 0;
}