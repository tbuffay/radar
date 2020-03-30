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

#define MAXLINE 1024 
#define PORT     8080 
#define DATA_SIZE 1216 
#define GPIO_BASE_ADDR 0x1000000

char get_gpio_value()
{
	int gpio_fd=0;
    char gpio_str[2];
	gpio_fd=open("/sys/class/gpio/gpio902/value", O_RDWR);
    if (gpio_fd < 0) 
	{
        printf("Cannot open GPIO to export 902\n");
        return 0;
    }
	read(gpio_fd, gpio_str, sizeof(gpio_str));
	close(gpio_fd);
	return gpio_str[0];
}
// Driver code 
int main(int argc,char **argv) 
{
    int sockfd;
    char *hello = "Hello from leon client";
    struct sockaddr_in       servaddr;
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    memset(&servaddr, 0, sizeof(servaddr));
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = INADDR_ANY;
    if(argc>=2)
    {
        inet_pton(AF_INET,argv[1],&(servaddr.sin_addr));
    }
    if(argc>=3){
       int sport;
       sscanf(argv[2],"%d",&sport);
       servaddr.sin_port=htons(sport);
    }
    sendto(sockfd, (const char *)hello,sizeof(hello),MSG_CONFIRM, (const struct sockaddr *) &servaddr,sizeof(servaddr));
    printf("udp sent.\n");
    close(sockfd);
    return 0;
}
int main_func(int argc,char **argv) 
{
    int sockfd;
    char buffer[MAXLINE];
    char *hello = "Hello from leon client";
    struct sockaddr_in       servaddr;
	unsigned char * map_base;
    int mem_fd;
	char gpioValue;
	char cTemp='0';
 
    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
 
    memset(&servaddr, 0, sizeof(servaddr));
 
    // Filling server information 
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = INADDR_ANY;
 
    if(argc>=2)
    {
        inet_pton(AF_INET,argv[1],&(servaddr.sin_addr));
    }
    if(argc>=3){
       int sport;
       sscanf(argv[2],"%d",&sport);
       servaddr.sin_port=htons(sport);
    }
	
	mem_fd = open("/dev/mem", O_RDWR|O_SYNC);
    if (mem_fd == -1)
    {
		printf("cannot open mem dev.\n");
		close(sockfd);
        return 0;
    }	
	do
	{
		gpioValue = get_gpio_value();
		printf("gpio value:%c.\n",gpioValue);
		if (cTemp == gpioValue)
		{
			printf("continue\n");
		}
		else
		{
			cTemp = gpioValue;
			if (gpioValue=='1')
			{
				map_base = mmap(NULL, DATA_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, mem_fd, GPIO_BASE_ADDR);
				if (map_base == 0)
				{
					printf("NULL pointer!\n");
					close(sockfd);
					close(mem_fd);
					return 0;
				}
				sendto(sockfd, (const char *)map_base, DATA_SIZE,
					MSG_CONFIRM, (const struct sockaddr *) &servaddr,
                       sizeof(servaddr));
				printf("udp sent.\n");
			}
		}
	}while(1);
	close(sockfd);
	close(mem_fd);
    munmap(map_base, 0xff);
    return 0;
}
