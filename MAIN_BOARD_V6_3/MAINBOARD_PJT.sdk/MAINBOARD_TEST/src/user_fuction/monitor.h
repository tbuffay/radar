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
#define TOP_MONITOR_BASEADDR XPAR_YF_AXILITE_LIDAR_BASEADDR
#define MAIN_MONITOR_BASEADDR XPAR_YF_AXI_LITE_MONITOR_S00_AXI_BASEADDR

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

#define POWER_V_MONITOR_OFFSET				0x20/*�����ѹ*/
#define POWER_I_MONITOR_OFFSET				0x22/*�������*/
#define MAIN_MONITOR_3V3_OFFSET				0x24/*�װ�3V3*/
#define MAIN_MONITOR_TEMP_OFFSET			0x28/*�װ��¶�*/
#define MAIN_MONITOR_5V_OFFSET				0x2c/*�װ�5V*/

typedef struct {
	float PowerV;
	float PowerI;
	float Vcc33;
	float Temperature;
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
