#!/bin/sh
echo 898 > /sys/class/gpio/export
echo 899 > /sys/class/gpio/export
echo 900 > /sys/class/gpio/export
echo 901 > /sys/class/gpio/export
echo 903 > /sys/class/gpio/export
echo 904 > /sys/class/gpio/export
echo 905 > /sys/class/gpio/export
echo in > /sys/class/gpio/gpio898/direction
echo in > /sys/class/gpio/gpio899/direction
echo out > /sys/class/gpio/gpio900/direction
echo out > /sys/class/gpio/gpio901/direction
echo out > /sys/class/gpio/gpio903/direction
echo out > /sys/class/gpio/gpio904/direction
echo out > /sys/class/gpio/gpio905/direction
echo 1 > /sys/class/gpio/gpio901/value #ç”µæ
sleep 5
echo 1 > /sys/class/gpio/gpio900/value #é¡¶æ