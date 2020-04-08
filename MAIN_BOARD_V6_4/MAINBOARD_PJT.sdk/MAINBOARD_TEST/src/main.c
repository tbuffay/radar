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
	u8 UiOrderArray[18];
	u8 TestSel=0;
	u32 AxiGpioState=0;
	u32 data=0;
	float fdata=0.0;
	float fdata1=0.0;
	/**********************************/
	AxiGpioInit();
	PsGpioInit();
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
/******************************************************************///
///*
	while(1){
		/*irq*/
		if(Isqflag){
			Isqflag=0;
			if(data==1000){
				data=0;
			}
			else {
				data=data+1;
			}
		}
		/*uart*/
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
					case 0x00:{						//正常工作
						DebugRotorShut();
						MotorOplopShut();
						break;
					}
					case 0x01:{						//调试
						DebugRotorEn();
						if(UiOrderArray[16]==1){
							TestSel=0x06;
							SolidRotorParamEn();
							SolidRotorParamShut();
						}
						else{
							if(UiOrderArray[3]==1){//开环：调试死区时间和超前角
								MotorOplopEn();
								MotorParameterInst.set_speed=(u32)(UiOrderArray[4]<<8 | UiOrderArray[5]);
								MotorParameterInst.adcance_angle=(u16)(UiOrderArray[7]<<8|UiOrderArray[8]);
								MotorParameterInst.dead_zone=(u16)UiOrderArray[6];
								SetMotorSpeed();
								SetMotorOParameter();
							}
							else{//闭环：调试PI参数
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
					case 0x02:{
						TestSel=UiOrderArray[3];
						break;
					}
					case 0x03:{
						if(UiOrderArray[3]==0x1){TopPowerOn();}
						else {TopPowerOff();}
						break;
					}
					default:break;
				}
				if(UiOrderArray[2]==1){	MotorEn();}
				else {MotorShut();}
			}
		}
//*/
/******************************************************************/
//*
		//TestSel=1;
		switch(TestSel){
			/*debug motor*/
			case 0x01:{
				GetMotorState();
				printf( "%.2f %.2f %.2f %.2f \n"
						,MotorStateInst.speed
						,MotorStateInst.angle
						,MotorStateInst.current
						,MotorStateInst.voltage
				);
				break;
			}
			/*monitor power*/
			case 0x02:{
				Monitor();
				printf( "*********************\n"
						"PowerV: %.2f\n"
						"PowerI: %.2f\n"
						"Temperature: %.2f\n"
						"Vcc5: %.2f\n"
						"Vcc33: %.2f\n"
						,MonitorInst.main_monitor.PowerV
						,MonitorInst.main_monitor.PowerI
						,MonitorInst.main_monitor.Temperature
						,MonitorInst.main_monitor.Vcc5
						,MonitorInst.main_monitor.Vcc33
				);
				sleep(1);
				break;
			}
			/*test encoders*/
			case 0x03:{
				GetMotorState();
				fdata1=fdata;
				fdata=MotorStateInst.angle;
				if(fdata!=fdata1){printf( "%.2f \n",fdata);}
				break;
			}
			/*test gps*/
			case 0x04:{
				AxiGpioState=AxiGetGpioState();
				if((int)(AxiGpioState&0x00000001)>0){
					GetGps();
					u16 i;
					for(i=0;i<70;i++){printf( "%c",GpsArray[i]);}
					printf( "\n");
					sleep(1);
				}
				break;
			}
			/*test wireless*/
			case 0x05:{
				if(data>500){PsLedOn();}
				else{PsLedOff();}
				//sleep(1);
				break;
			}//*/
			/**/
			case 0x06:{
				AxiGpioState=AxiGetGpioState();
				if((int)(AxiGpioState&0x00000004)>0){PsLedOn();}
				else{PsLedOff();}
				break;
			}
			default:break;
		}
//*/
/******************************************************************/
	}
	return 0;
}
