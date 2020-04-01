#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <float.h>
#include <limits.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include <unistd.h>

#define MEMDEV_IOC_MAGIC 'k'
#define MEMDEV_IOCGETMOTOR _IOR(MEMDEV_IOC_MAGIC, 5, int *)

int ReadMotor()
{
    int motorStat[3] = {0};
    float fMotorStat[4] = {0.0};
    int fd = open("/dev/irq_drv", O_RDWR);
    FILE *fp = fopen("readMotor.txt", "a+");
    if (fd < 0)
    {
        printf("Open Dev irq_drv Error!\n");
        return;
    }
    if (ioctl(fd, MEMDEV_IOCGETMOTOR, motorStat) < 0)
    {
        printf("Call ioctl fail\n");
        return;
    }
    fMotorStat[0] = motorStat[0] / 10.0;
    fMotorStat[1] = motorStat[1] / 100.0;
    fMotorStat[2] = (motorStat[2] & 0xFFFF) / 1000.0;
    fMotorStat[3] = ((motorStat[2] >> 16) & 0xFFFF) / 10.0;
    fprintf(fp, "%.1f %.2f %.3f %.1f\n", fMotorStat[0], fMotorStat[1], fMotorStat[2], fMotorStat[3]);
    close(fd);
    fclose(fp);
    return 0;
}
void MainFunc()
{
    char c = '\0';
    FILE *fpDebugMode = NULL;
    fpDebugMode = fopen("/sys/class/gpio/gpio905/value", "r+");
    if (fpDebugMode != NULL)
    {
        fread(&c, 1, 1, fpDebugMode);
        if (c == '1')
        {
            ReadMotor();
        }
        else
            sleep(1);
        fclose(fpDebugMode);
    }
}
int main()
{
    while (1)
    {
        MainFunc();
        usleep(30000);
    }
    return 0;
}