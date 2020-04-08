/*
 * interrupt.h
 *
 *  Created on: 2019Äê2ÔÂ25ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_USER_FUCTION_INTERRUPT_H_
#define SRC_USER_FUCTION_INTERRUPT_H_

#include "xscugic.h"
#include "user_uart.h"
XScuGic myXScuGic;

#define GIC_DEVICE_ID XPAR_PS7_SCUGIC_0_DEVICE_ID
#define DATA_PACKET_IRQ_ID 61U
#define UART_INT_IRQ_ID	82U

int InterruptInitial(void);

#endif /* SRC_USER_FUCTION_INTERRUPT_H_ */
