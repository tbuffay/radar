/*
 * Placeholder PetaLinux user application.
 *
 * Replace this with your application code
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include<sys/mman.h>
#include<sys/stat.h>
#include<fcntl.h>

#define GPIO_BASE_ADDR 0x40000000
#define DATA_SIZE 1216 
#define dev_name "/dev/mem"
int main(int argc, char *argv[])
{
	unsigned char * map_base;
	int mem_fd = open(dev_name, O_RDWR|O_SYNC);
	if (mem_fd == -1)
    	{
		printf("cannot open mem dev %s\n",dev_name);
        	return -1;
   	}
	map_base = mmap(NULL, DATA_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, mem_fd, GPIO_BASE_ADDR);
	if (map_base == 0)
	{
		printf("NULL pointer!\n");
		close(mem_fd);
		return -1;
	}
	return 0;
}


