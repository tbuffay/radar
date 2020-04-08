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

#include <stdio.h>
#include "xparameters.h"
//#include "xil_printf.h"
#include "sleep.h"

#include "user_fuction\user_fuction.h"

volatile u32 Isqflag,UartRevflag;
volatile u32 ReceivedByteNum;

/**************************************************************************/
int main()
{
	/**********************************/
	u16 UiOrder=0;
	u32 UiOrderFlag=0;
	u16	TopSpeed=0;
	u16*TopSpeed_p=(u16*)(0x40000000+0x54e);
	Isqflag=0;
	UartRevflag=0;
	ReceivedByteNum=0;
	u32 SendByteNum=0;
	u8 UiOrderArray[16];
	u8 data;
	/**********************************/
	GpioInit();
	MotorInit();
	UartPsInt();
	SetMotorSpeed( (u16)600);
	InterruptInitial();
	/**********************************/
	MotorEn();
	sleep(5);
//	TopPowerOn();

	XScuGic_Enable(&myXScuGic, DATA_PACKET_IRQ_ID);
//	XScuGic_Enable(&myXScuGic, UART_INT_IRQ_ID);
	/**********************************/
	while(1){

		if(Isqflag){
			Isqflag=0;
			Monitor();
			GetMotorState();
			xil_printf("%d %d \n",MotorStateInst.measure_angle,MotorStateInst.measure_speed);
			TopSpeed=(u16)*TopSpeed_p;
//			if(UiOrderFlag==0){
//				SetMotorSpeed(TopSpeed);
//			}
		}

		if(UartRevflag){
			UartRevflag=0;
			RecvBufferPtr = RecvBuffer;
			SendByteNum = ReceivedByteNum ;
			ReceivedByteNum = 0 ;
			memset(UiOrderArray,0x00,sizeof(UiOrderArray)) ;
			memcpy(UiOrderArray,RecvBuffer,SendByteNum) ;
			UartPsSend(UiOrderArray, SendByteNum);
			if(UiOrderArray[0]==0xfa && UiOrderArray[8]==0xbe ){
				switch(UiOrderArray[1]){
				case 0x00:{
					UiOrderFlag=0;
					break;
				}
				case 0x01:{
					UiOrder=UiOrderArray[2]<<8 | UiOrderArray[3];
					SetMotorSpeed( (u16)UiOrder);
					UiOrderFlag=1;
					break;
				}
				default:break;
				}
			}
		}
	}
	return 0;
}
