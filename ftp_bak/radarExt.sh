#!/bin/sh
path=/var/ftp
chmod +x $path/ifconfig.sh
source $path/ifconfig.sh
insmod $path/irq_drv.ko
chmod +x $path/gpioSet.sh
source $path/gpioSet.sh
chmod +x $path/httpd
$path/httpd -h $path
#chmod +x $path/update.sh
#source $path/update.sh &