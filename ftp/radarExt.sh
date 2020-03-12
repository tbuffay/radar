#!/bin/sh
path=/var/ftp
chmod +x $path/ifconfig.sh
source $path/ifconfig.sh
chmod +x $path/httpd
$path/httpd -h $path
#insmod $path/irq_drv.ko
chmod +x $path/update.sh
source $path/update.sh &