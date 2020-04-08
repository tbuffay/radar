/*
 * main_monitor.c

 *
 *  Created on: 2019Äê2ÔÂ25ÈÕ
 *      Author: Administrator
 */

#include "monitor.h"

void Monitor(void){

/*top monitor*/
	MonitorInst.top_monitor.temp =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_TEMP_OFFSET) ))/10.0);

	MonitorInst.top_monitor.sample_hv =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_HV_OFFSET) ))/10.0);

	MonitorInst.top_monitor.voltage_12v =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_12V_OFFSET) ))/10.0);

	MonitorInst.top_monitor.voltage_8v =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_8V_OFFSET) ))/10.0);

	MonitorInst.top_monitor.voltage_5v =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_5V_OFFSET) ))/10.0);

	MonitorInst.top_monitor.voltage_3v =
			(float)((*( (u16*)(MONITOR_BASEADDR+TOP_MONITOR_3V3_OFFSET) ))/10.0);

	MonitorInst.top_monitor.hardware =
			(char)(*( (u8*)(MONITOR_BASEADDR+TOP_MONITOR_HARDWARE_VERSION_OFFSET) ));

	MonitorInst.top_monitor.software =
			(char)(*( (u8*)(MONITOR_BASEADDR+TOP_MONITOR_SOFTWARE_VERSION_OFFSET) ));

	MonitorInst.top_monitor.agree_version =
			(char)(*( (u8*)(MONITOR_BASEADDR+TOP_MONITOR_AGREE_VERSION_OFFSET) ));

	MonitorInst.top_monitor.function_version =
			(char)(*( (u8*)(MONITOR_BASEADDR+TOP_MONITOR_FUNCTION_VERSION_OFFSET) ));

	MonitorInst.top_monitor.error =
			(char)(*( (u8*)(MONITOR_BASEADDR+TOP_MONITOR_ERROR_OFFSET) ));


/*main monitor*/
	MonitorInst.main_monitor.Vcc33 = ( (float)(
					(*( (u16*)(MONITOR_BASEADDR+MAIN_MONITOR_3V3_OFFSET) ))
					&0x0fff)/4096 )*5;

	MonitorInst.main_monitor.Temperature = 128870*sqrtf(
			0.00016118-( (float)(
					(*( (u16*)(MONITOR_BASEADDR+MAIN_MONITOR_TEMP_OFFSET) ))
					&0x0fff)/4096 )*5*0.00001552
			)-1482;

	MonitorInst.main_monitor.PowerI =(( (float)(
					(*( (u16*)(MONITOR_BASEADDR+MAIN_MONITOR_PI_OFFSET) ))
					&0x0fff)/4096 )*5-2.5
			)*10;


	MonitorInst.main_monitor.PowerV =( (float)(
					(*( (u16*)(MONITOR_BASEADDR+MAIN_MONITOR_PV_OFFSET) ))
					&0x0fff)/4096 )*5*11;

	MonitorInst.main_monitor.Vcc5 =( (float)(
			(*( (u16*)(MONITOR_BASEADDR+MAIN_MONITOR_5V_OFFSET) ))
			&0x0fff)/4096 )*5*2;
}
