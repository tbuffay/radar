/*
 * user_uart.c
 *
 *  Created on: 2019Äê4ÔÂ16ÈÕ
 *      Author: Administrator
 */

#include "user_uart.h"


XUartPsFormat UartFormatInst =
{
		115200,
		XUARTPS_FORMAT_8_BITS,
		XUARTPS_FORMAT_NO_PARITY,
		XUARTPS_FORMAT_1_STOP_BIT
};

/**************************************************************************/

int UartPsInt(void){
	int Status;
	XUartPs_Config *Config;
	Config = XUartPs_LookupConfig(UART_DEVICE_ID);
	if (NULL == Config) {
		return XST_FAILURE;
	}
	Status = XUartPs_CfgInitialize(&UartPsInst, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	/* Use Normal mode. */
	XUartPs_SetOperMode(&UartPsInst, XUARTPS_OPER_MODE_NORMAL);
	/* Set uart mode Baud Rate 115200, 8bits, no parity, 1 stop bit */
	XUartPs_SetDataFormat(&UartPsInst, &UartFormatInst) ;
	/*Set receiver FIFO interrupt trigger level, here set to 1*/
	XUartPs_SetFifoThreshold(&UartPsInst,18) ;
	/*gets the Receive Timeout*/
//	data= XUartPs_GetRecvTimeout(&UartPsInst);
	/* Set the RX timeout to 2*/
	XUartPs_SetRecvTimeout(&UartPsInst, (u8)8);
	/* Enable the receive FIFO trigger level interrupt and empty interrupt for the device */
	XUartPs_SetInterruptMask(&UartPsInst,XUARTPS_IXR_RXOVR|XUARTPS_IXR_RXEMPTY);

	XUartPs_WriteReg(UartPsInst.Config.BaseAddress, XUARTPS_ISR_OFFSET, 0xFFFFFFFF) ;

	return XST_SUCCESS;
}
/**************************************************************************/
int UartPsSend(u8 *BufferPtr, u32 NumBytes)
{

	u32 SentCount = 0U;

	/* Setup the buffer parameters */
	UartPsInst.SendBuffer.RequestedBytes = NumBytes;
	UartPsInst.SendBuffer.RemainingBytes = NumBytes;
	UartPsInst.SendBuffer.NextBytePtr = BufferPtr;


	while (UartPsInst.SendBuffer.RemainingBytes > SentCount)
	{
		/* Fill the FIFO from the buffer */
		if (!XUartPs_IsTransmitFull(UartPsInst.Config.BaseAddress))
		{
			XUartPs_WriteReg(UartPsInst.Config.BaseAddress,
					XUARTPS_FIFO_OFFSET,
					((u32)UartPsInst.SendBuffer.
							NextBytePtr[SentCount]));

			/* Increment the send count. */
			SentCount++;
		}
	}

	/* Update the buffer to reflect the bytes that were sent from it */
	UartPsInst.SendBuffer.NextBytePtr += SentCount;
	UartPsInst.SendBuffer.RemainingBytes -= SentCount;


	return SentCount;
}
/**************************************************************************/
int UartPsRev(u8 *BufferPtr, u32 NumBytes)
{
	u32 ReceivedCount = 0;
	u32 CsrRegister;

	/* Setup the buffer parameters */
	UartPsInst.ReceiveBuffer.RequestedBytes = NumBytes;
	UartPsInst.ReceiveBuffer.RemainingBytes = NumBytes;
	UartPsInst.ReceiveBuffer.NextBytePtr = BufferPtr;

	/*
	 * Read the Channel Status Register to determine if there is any data in
	 * the RX FIFO
	 */
	CsrRegister = XUartPs_ReadReg(UartPsInst.Config.BaseAddress,
			XUARTPS_SR_OFFSET);

	/*
	 * Loop until there is no more data in RX FIFO or the specified
	 * number of bytes has been received
	 */
	while((ReceivedCount < UartPsInst.ReceiveBuffer.RemainingBytes)&&
			(((CsrRegister & XUARTPS_SR_RXEMPTY) == (u32)0)))
	{
		UartPsInst.ReceiveBuffer.NextBytePtr[ReceivedCount] =
				XUartPs_ReadReg(UartPsInst.Config.BaseAddress,XUARTPS_FIFO_OFFSET);

		ReceivedCount++;

		CsrRegister = XUartPs_ReadReg(UartPsInst.Config.BaseAddress,
				XUARTPS_SR_OFFSET);
	}
	UartPsInst.is_rxbs_error = 0;
	/*
	 * Update the receive buffer to reflect the number of bytes just
	 * received
	 */
	if(UartPsInst.ReceiveBuffer.NextBytePtr != NULL){
		UartPsInst.ReceiveBuffer.NextBytePtr += ReceivedCount;
	}
	UartPsInst.ReceiveBuffer.RemainingBytes -= ReceivedCount;

	return ReceivedCount;
}
/**************************************************************************/
/*no more*/
