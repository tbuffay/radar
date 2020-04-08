/*
 * gps.h
 *
 *  Created on: 2020Äê3ÔÂ20ÈÕ
 *      Author: ThinKpad
 */

#ifndef SRC_USER_FUCTION_GPS_H_
#define SRC_USER_FUCTION_GPS_H_

#include "xstatus.h"

#define GPS_BASEADDR XPAR_YF_AXILITE_GPS_BASEADDR

u8 GpsArray[256];

void GetGps(void);

#endif /* SRC_USER_FUCTION_GPS_H_ */
