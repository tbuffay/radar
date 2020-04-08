/*
 * monitor.h
 *
 *  Created on: 2019Äê2ÔÂ25ÈÕ
 *      Author: Administrator
 */

#ifndef SRC_USER_FUCTION_MONITOR_H_
#define SRC_USER_FUCTION_MONITOR_H_

#include "xstatus.h"
#include "math.h"
#include "xparameters.h"

/************************************************/
#define MONITOR_BASEADDR XPAR_BRAM_0_BASEADDR

#define TOP_MONITOR_TEMP_OFFSET				0x4c4/*¶¥°åÎÂ¶È*/
#define TOP_MONITOR_HV_OFFSET				0x4c2/*¶¥°å²ÉÑù¸ßÑ¹*/
#define TOP_MONITOR_12V_OFFSET				0x4c0/*¶¥°å12V*/
#define TOP_MONITOR_8V_OFFSET				0x4ca/*¶¥°å8V*/
#define TOP_MONITOR_5V_OFFSET				0x4c8/*¶¥°å5V*/
#define TOP_MONITOR_3V3_OFFSET				0x4c6/*¶¥°å3V3*/
#define TOP_MONITOR_HARDWARE_VERSION_OFFSET	0x4cf/*¶¥°åÓ²¼þ°æ±¾ºÅ*/
#define TOP_MONITOR_SOFTWARE_VERSION_OFFSET	0x4ce/*¶¥°åÈí¼þ°æ±¾ºÅ*/
#define TOP_MONITOR_AGREE_VERSION_OFFSET	0x4cd/*¶¥°åÐ­Òé°æ±¾ºÅ*/
#define TOP_MONITOR_FUNCTION_VERSION_OFFSET	0x4cc/*¶¥°å¹¦ÄÜ°æ±¾ºÅ*/
#define TOP_MONITOR_ERROR_OFFSET			0x4cb/*¶¥°å´íÎóºÅ*/

#define MAIN_MONITOR_3V3_OFFSET				0x560/*µ×°å3V3*/
#define MAIN_MONITOR_TEMP_OFFSET			0x568/*µ×°åÎÂ¶È*/
#define MAIN_MONITOR_PI_OFFSET				0x56a/*µ×°åÊäÈëµçÁ÷*/
#define MAIN_MONITOR_PV_OFFSET				0x56c/*µ×°åÊäÈëµçÑ¹*/
#define MAIN_MONITOR_5V_OFFSET				0x56e/*µ×°å5V*/

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
