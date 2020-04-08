/*
 * monitor.h
 *
 *  Created on: 2019��2��25��
 *      Author: Administrator
 */

#ifndef SRC_USER_FUCTION_MONITOR_H_
#define SRC_USER_FUCTION_MONITOR_H_

#include "xstatus.h"
#include "math.h"
#include "xparameters.h"

/************************************************/
#define MONITOR_BASEADDR XPAR_BRAM_0_BASEADDR

#define TOP_MONITOR_TEMP_OFFSET				0x4c4/*�����¶�*/
#define TOP_MONITOR_HV_OFFSET				0x4c2/*���������ѹ*/
#define TOP_MONITOR_12V_OFFSET				0x4c0/*����12V*/
#define TOP_MONITOR_8V_OFFSET				0x4ca/*����8V*/
#define TOP_MONITOR_5V_OFFSET				0x4c8/*����5V*/
#define TOP_MONITOR_3V3_OFFSET				0x4c6/*����3V3*/
#define TOP_MONITOR_HARDWARE_VERSION_OFFSET	0x4cf/*����Ӳ���汾��*/
#define TOP_MONITOR_SOFTWARE_VERSION_OFFSET	0x4ce/*��������汾��*/
#define TOP_MONITOR_AGREE_VERSION_OFFSET	0x4cd/*����Э��汾��*/
#define TOP_MONITOR_FUNCTION_VERSION_OFFSET	0x4cc/*���幦�ܰ汾��*/
#define TOP_MONITOR_ERROR_OFFSET			0x4cb/*��������*/

#define MAIN_MONITOR_3V3_OFFSET				0x560/*�װ�3V3*/
#define MAIN_MONITOR_TEMP_OFFSET			0x568/*�װ��¶�*/
#define MAIN_MONITOR_PI_OFFSET				0x56a/*�װ��������*/
#define MAIN_MONITOR_PV_OFFSET				0x56c/*�װ������ѹ*/
#define MAIN_MONITOR_5V_OFFSET				0x56e/*�װ�5V*/

typedef struct {
	float Vcc33;
	float Temperature;
	float PowerI;
	float PowerV;
	float Vcc5;
} MainMonitor_t;

typedef struct {
	float temp;
	float sample_hv;
	float voltage_12v;
	float voltage_8v;
	float voltage_5v;
	float voltage_3v;
	char hardware;
	char software;
	char agree_version;
	char function_version;
	char error;
} TopMonitor_t;

typedef struct {
	MainMonitor_t main_monitor;
	TopMonitor_t top_monitor;
} Monitor_t;


Monitor_t MonitorInst;

void Monitor(void);

#endif /* SRC_USER_FUCTION_MONITOR_H_ */
