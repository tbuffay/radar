#!/bin/sh

while true
do
 if [ -a /var/ftp/SYS_UPDATE ]
 then
  rm -fr /var/ftp/SYS_UPDATE
  flashcp /var/ftp/image.ub /dev/mtd2
  flashcp /var/ftp/BOOT.BIN /dev/mtd0
 fi
 sleep 1
done
