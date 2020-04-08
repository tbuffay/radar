/*
 * interrupt.c
 *
 *  Created on: 2019Äê2ÔÂ25ÈÕ
 *      Author: Administrator
 */


#include "interrupt.h"
#include "axi_gpio_control.h"

extern volatile u32 Isqflag,UartRevflag;
extern volatile u32 ReceivedByteNum;
/**************************************************************************/
void IrqHandler(void){
//	XScuGic_Disable(&myXScuGic, DATA_PACKET_IRQ_ID);
	IptClearSet();

	Isqflag=1;

	IptClearSetClear();
//	XScuGic_Enable(&myXScuGic, DATA_PACKET_IRQ_ID);
}/**************************************************************************/
void UartRevIntHandler( void* CallBackRef){
	XUartPs *UartPsInstPtr = (XUartPs *) CallBackRef ;
	XScuGic_Disable(&myXScuGic, UART_INT_IRQ_ID);
	u32 ReceivedCount = 0 ;
	u32 UartSrValue ;

	UartSrValue = XUartPs_ReadReg(UartPsInstPtr->Config.BaseAddress, XUARTPS_SR_OFFSET) & (XUARTPS_IXR_RXOVR|XUARTPS_IXR_RXEMPTY);

	if (UartSrValue & XUARTPS_IXR_RXOVR)   /* check if receiver FIFO trigger */
	{
		ReceivedCount = UartPsRev(RecvBuffer, MAX_LEN) ;
		ReceivedByteNum += ReceivedCount ;
		RecvBufferPtr += ReceivedCount ;
		/* clear trigger interrupt */
		XUartPs_WriteReg(UartPsInstPtr->Config.BaseAddress, XUARTPS_ISR_OFFSET, XUARTPS_IXR_RXOVR) ;
	}
	else if (UartSrValue & XUARTPS_IXR_RXEMPTY)       /*check if receiver FIFO empty */
	{
		/* clear empty interrupt */
		XUartPs_WriteReg(UartPsInstPtr->Config.BaseAddress, XUARTPS_ISR_OFFSET, XUARTPS_IXR_RXEMPTY) ;
		UartRevflag = 1 ;
	}
	XScuGic_Enable(&myXScuGic, UART_INT_IRQ_ID);
}
/**************************************************************************/
int InterruptInitial(void){

	XScuGic_Config *myXScuGic_Config;
	int status;
	myXScuGic_Config = XScuGic_LookupConfig(GIC_DEVICE_ID);
	status = XScuGic_CfgInitialize(&myXScuGic, myXScuGic_Config, myXScuGic_Config->CpuBaseAddress);

	if(status != XST_SUCCESS) return XST_FAILURE;

	XScuGic_SetPriorityTriggerType(&myXScuGic, DATA_PACKET_IRQ_ID,	0xb0, 0x03);
	XScuGic_SetPriorityTriggerType(&myXScuGic, UART_INT_IRQ_ID,	0xa0, 0x01);

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT, (Xil_ExceptionHandler)XScuGic_InterruptHandler, &myXScuGic);
	Xil_ExceptionEnable();

	status = XScuGic_Connect(&myXScuGic, DATA_PACKET_IRQ_ID, (Xil_InterruptHandler)IrqHandler, (void *)0);
	if(status != XST_SUCCESS) return XST_FAILURE;

	status = XScuGic_Connect(&myXScuGic, UART_INT_IRQ_ID,(XInterruptHandler) UartRevIntHandler,(void *) &UartPsInst);
	if (status != XST_SUCCESS) 	return XST_FAILURE;

	XScuGic_Disable(&myXScuGic, DATA_PACKET_IRQ_ID);
	XScuGic_Disable(&myXScuGic, UART_INT_IRQ_ID);

	return XST_SUCCESS;
}
