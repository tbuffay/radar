/*
 * monitor.h
 *
 *  Created on: 2019年2月25日
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

#define TOP_MONITOR_TEMP_OFFSET				0x4c4/*顶板温度*/
#define TOP_MONITOR_HV_OFFSET				0x4c2/*顶板采样高压*/
#define TOP_MONITOR_12V_OFFSET				0x4c0/*顶板12V*/
#define TOP_MONITOR_8V_OFFSET				0x4ca/*顶板8V*/
#define TOP_MONITOR_5V_OFFSET				0x4c8/*顶板5V*/
#define TOP_MONITOR_3V3_OFFSET				0x4c6/*顶板3V3*/
#define TOP_MONITOR_HARDWARE_VERSION_OFFSET	0x4cf/*顶板硬件版本号*/
#define TOP_MONITOR_SOFTWARE_VERSION_OFFSET	0x4ce/*顶板软件版本号*/
#define TOP_MONITOR_AGREE_VERSION_OFFSET	0x4cd/*顶板协议版本号*/
#define TOP_MONITOR_FUNCTION_VERSION_OFFSET	0x4cc/*顶板功能版本号*/
#define TOP_MONITOR_ERROR_OFFSET			0x4cb/*顶板错误号*/

#define POWER_V_MONITOR_OFFSET				0x20/*输入电压*/
#define POWER_I_MONITOR_OFFSET				0x22/*输入电流*/
#define MAIN_MONITOR_3V3_OFFSET				0x24/*底板3V3*/
#define MAIN_MONITOR_TEMP_OFFSET			0x28/*底板温度*/
#define MAIN_MONITOR_5V_OFFSET				0x2c/*底板5V*/

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
