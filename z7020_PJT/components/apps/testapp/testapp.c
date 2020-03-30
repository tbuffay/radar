/*
 * Placeholder PetaLinux user application.
 *
 * Replace this with your application code
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <poll.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <linux/ioctl.h>

/* 定义幻数 */
#define MEMDEV_IOC_MAGIC  'k'

/* 定义命令 */
#define MEMDEV_IOCPRINT   _IO(MEMDEV_IOC_MAGIC, 1)
#define MEMDEV_IOCGETDATA _IOR(MEMDEV_IOC_MAGIC, 2, int)
#define MEMDEV_IOCSETDATA _IOW(MEMDEV_IOC_MAGIC, 3, int)

#define MEMDEV_IOC_MAXNR 3

int main(int argc, char *argv[])
{
	int cmd;
    	int arg = 60000;
	int fd = open("/dev/irq_drv", O_RDWR);
	if (fd < 0)
    	{
        	printf("Open Dev Mem0 Error!\n");
        	return -1;
    	}
//	cmd = _IOW(0x55,_IOC_WRITE,sizeof(int));
    	printf("<--- Call MEMDEV_IOCPRINT --->\n");
	cmd = MEMDEV_IOCSETDATA;
    	if (ioctl(fd, cmd, &arg) < 0)
        {
        	printf("Call cmd MEMDEV_IOCPRINT fail\n");
            	return -1;
    	}
	printf("Hello, PetaLinux World!\n");
	printf("cmdline args:\n");
	while(argc--)
		printf("%s\n",*argv++);

	return 0;
}


