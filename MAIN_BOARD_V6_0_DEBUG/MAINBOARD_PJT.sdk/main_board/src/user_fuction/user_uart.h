/*
 * user_uart.h
 *
 *  Created on: 2019Äê4ÔÂ16ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_USER_FUCTION_USER_UART_H_
#define SRC_USER_FUCTION_USER_UART_H_


/***************************** Include Files *******************************/

#include "xparameters.h"
#include "xuartps.h"
#include "xscugic.h"
/************************** Constant Definitions **************************/

#define UART_DEVICE_ID		XPAR_XUARTPS_0_DEVICE_ID

#define MAX_LEN	1000



/************************** Variable Definitions ***************************/

//XUartPsFormat UartFormatInst;
XUartPs UartPsInst;		/* Instance of the UART Device */

/*
 * The following buffers are used in this example to send and receive data
 * with the UART.
 */
u8 SendBuffer[MAX_LEN];	/* Buffer for Transmitting Data */
u8 RecvBuffer[MAX_LEN];	/* Buffer for Receiving Data */
u8 *SendBufferPtr;
u8 *RecvBufferPtr;

/************************** Function Prototypes *****************************/
int UartPsInt(void);
int UartPsSend(u8 *BufferPtr, u32 NumBytes) ;
int UartPsRev (u8 *BufferPtr, u32 NumBytes) ;
/**************************************************************************/
/*no more*/

#endif /* SRC_USER_FUCTION_USER_UART_H_ */
