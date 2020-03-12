#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/types.h>
#include <linux/err.h>
#include <linux/io.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/of.h>
#include <linux/delay.h>

#include <linux/dma-mapping.h>

#include <linux/pm.h>
#include <linux/fs.h>
#include <linux/slab.h>
#include <linux/gfp.h>
#include <linux/mm.h>
#include <linux/dma-buf.h>
#include <linux/string.h>
#include <linux/uaccess.h>
#include <linux/dmaengine.h>
#include <linux/completion.h>
#include <linux/wait.h>
#include <linux/init.h>

#include <linux/sched.h>
#include <linux/pagemap.h>
#include <linux/errno.h> /* error codes */
#include <linux/clk.h>
#include <linux/interrupt.h>
#include <linux/vmalloc.h>

#include <linux/moduleparam.h>
#include <linux/miscdevice.h>
#include <linux/ioport.h>
#include <linux/notifier.h>
#include <linux/init.h>
#include <linux/pci.h>

#include <linux/time.h>
#include <linux/timer.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/workqueue.h>
#include <linux/in.h>
#include <linux/inet.h>
#include <linux/socket.h>
#include <net/sock.h>
#include <asm/io.h>

static char devname[16];
static int major;
static int mijor;
static struct class *cls;
static int irq;
static struct device *dev;

#define DEVICE_NAME "irq_drv"
#define SERVER_IP "192.168.19.134"
#define DEST_IP_FILE "/var/ftp/destip.txt"
//#define SERVER_IP "192.168.19.24"
//#define SERVER_IP "255.255.255.255"
#define PORT 2368
#define UDP_DATASIZE 1206
#define MONITOR_OFFSET 0x560
#define XPAR_BRAM_0_BASEADDR 0x40000000
//#define MONITOR_BASEADDR XPAR_BRAM_0_BASEADDR
#define MOTOR_BASEADDR 0x43C00000
//#define GPIO_BASEADDR  0x41200000
#define GPIO_BASEADDR 0xd0840008
#define GPIO_DATASIZE 4
#define MOTOR_DATASIZE 0x40

#define TOP_MONITOR_TEMP_OFFSET 0x4c4 /*顶板温度*/
#define TOP_MONITOR_HV_OFFSET 0x4c2   /*顶板采样高压*/
#define TOP_MONITOR_12V_OFFSET 0x4c0  /*顶板12V*/
#define TOP_MONITOR_8V_OFFSET 0x4ca   /*顶板8V*/
#define TOP_MONITOR_5V_OFFSET 0x4c8   /*顶板5V*/
#define TOP_MONITOR_3V3_OFFSET 0x4c6  /*顶板3V3*/

#define MAIN_MONITOR_3V3_OFFSET 0x560
#define MAIN_MONITOR_TEMP_OFFSET 0x568
#define MAIN_MONITOR_PI_OFFSET 0x56a
#define MAIN_MONITOR_PV_OFFSET 0x56c
#define MAIN_MONITOR_5V_OFFSET 0x56e

#define DEBUG 0

struct S_Monitor
{
    short main_pi;
    short main_temp;
    short main_5v;
    short main_3v3;
    short main_pv;
    short top_hv;
    short top_temp;
    short top_12v;
    short top_8v;
    short top_5v;
    short top_3v;
};

/* 定义幻数 */
#define MEMDEV_IOC_MAGIC 'k'

/* 定义命令 */
#define MEMDEV_IOCPRINT _IO(MEMDEV_IOC_MAGIC, 1)
#define MEMDEV_IOCGETDATA _IOR(MEMDEV_IOC_MAGIC, 2, int)
#define MEMDEV_IOCSETSPEED _IOW(MEMDEV_IOC_MAGIC, 3, int)
#define MEMDEV_IOCGETMONITOR _IOR(MEMDEV_IOC_MAGIC, 4, struct S_Monitor)
#define MEMDEV_IOCSETLASER _IOW(MEMDEV_IOC_MAGIC, 5, int)
#define MEMDEV_IOC_MAXNR 5

char *dest_ip_addr = NULL;
char *data_map_addr = NULL;
void *motor_map_addr = NULL;
char *gpio_map_addr = NULL;
static struct socket *sock = NULL;
static struct work_struct work;
static volatile int irq_is_open = 0;
static struct fasync_struct *irq_async;
//struct timeval tv,now;
struct file *filp;
mm_segment_t fs;
loff_t pos = 0;
static int udp_sendto(struct socket *sock, char *buff, size_t len, unsigned flags, struct sockaddr *addr, int addr_len)
{
    struct kvec vec;
    struct msghdr msg;
    int ret;
    //long int ltemp;
    vec.iov_base = buff;
    vec.iov_len = len;

    memset(&msg, 0x00, sizeof(msg));
    msg.msg_name = addr;
    msg.msg_namelen = addr_len;
    msg.msg_flags = flags | MSG_DONTWAIT;
    ret = kernel_sendmsg(sock, &msg, &vec, 1, len);
    if (ret != 1206)
    {
        printk("udp send length = %d\n", ret);
    }
    return ret;
}
//char cTemp;
int iCount = 0;
static void powerOnMotor(void)
{
    char cValue;
    if(++iCount == 200)
    {
        cValue = readl(gpio_map_addr);
        printk("gpio value = %x\r\n", cValue);
        writel((unsigned char)(0x02 | cValue), gpio_map_addr);
    }
}
static void sendmsg(void *dummy)
{
    int n;
    struct sockaddr_in addr;
    memset(&addr, 0x00, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    //powerOnMotor();
    if (dest_ip_addr != NULL)
    {
        addr.sin_addr.s_addr = in_aton(dest_ip_addr);
    }
    else
    {
        printk("dest ip did not set yet.\n");
        return;
    }
    n = udp_sendto(sock, data_map_addr, UDP_DATASIZE, 0, (struct sockaddr *)&addr, sizeof(addr));
    
}
int ip_buff[0x10];
static int socket_init(void)
{
    int n = 0;
    loff_t pos;
    filp = filp_open(DEST_IP_FILE, O_RDONLY, 0);
    if (IS_ERR(filp))
    {
        printk("open destination ip file error.\n");
        dest_ip_addr = SERVER_IP;
    }
    else
    {
        fs = get_fs(); //change user buffer to kernel buffer
        set_fs(KERNEL_DS);
        if (filp->f_op && filp->f_op->read)
        {
            pos = filp->f_pos;
            n = filp->f_op->read(filp, ip_buff, sizeof(ip_buff), &pos);
            printk("ip_buff = %s\n", ip_buff);
            if (n < 7)
            {
                dest_ip_addr = SERVER_IP;
            }
            else
            {
                dest_ip_addr = ip_buff;
            }
        }
    }
    INIT_WORK(&work, sendmsg);
    sock_create_kern(PF_INET, SOCK_DGRAM, 0, &sock);
    return 0;
}

static int irq_drv_open(struct inode *Inode, struct file *File)
{
    irq_is_open = 1;
    return 0;
}

int irq_drv_release(struct inode *inode, struct file *file)
{
    //sock_release(sock);
    irq_is_open = 0;
    return 0;
}

static ssize_t irq_drv_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
{
    return 0;
}

static ssize_t irq_drv_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
{
    return 0;
}

static int irq_drv_fasync(int fd, struct file *filp, int on)
{
    return fasync_helper(fd, filp, on, &irq_async);
}

static void Xil_Out32(unsigned int *addr, unsigned int value)
{
    unsigned int *localAddr = (unsigned int *)addr;
    *localAddr = value;
}

static unsigned int Xil_In32(unsigned int *addr)
{
    return *(unsigned int *)addr;
}

int irq_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{

    int err = 0;
    int ret = 0;
    int speed = 0;
    int laser = 0;
    struct S_Monitor sMonitor;

    if (_IOC_TYPE(cmd) != MEMDEV_IOC_MAGIC)
        return -EINVAL;
    if (_IOC_NR(cmd) > MEMDEV_IOC_MAXNR)
        return -EINVAL;

    if (_IOC_DIR(cmd) & _IOC_READ)
        err = !access_ok(VERIFY_WRITE, (void *)arg, _IOC_SIZE(cmd));
    else if (_IOC_DIR(cmd) & _IOC_WRITE)
        err = !access_ok(VERIFY_READ, (void *)arg, _IOC_SIZE(cmd));
    if (err)
        return -EFAULT;

    switch (cmd)
    {
    case MEMDEV_IOCPRINT:
        break;
    case MEMDEV_IOCSETSPEED:
        ret = __get_user(speed, (int *)arg);
        printk("set speed = %d\n", speed);
        Xil_Out32((unsigned int *)(motor_map_addr), speed);
        break;
    case MEMDEV_IOCGETDATA:
        speed = Xil_In32((unsigned int *)(motor_map_addr + 4 * 8));
        //	printk("read speed = %d\r\n",speed);
        ret = __put_user(speed, (int *)arg);
        break;
    case MEMDEV_IOCSETLASER:
        ret = __get_user(laser, (int *)arg);
        printk("set laser = %d\n", laser);
        if (laser == 0)
        {
            writel((unsigned char)(0xFE & readl(gpio_map_addr)), gpio_map_addr);
        }
        else if (laser == 1)
        {
            writel((unsigned char)(0x01 | readl(gpio_map_addr)), gpio_map_addr);
        }
        break;
    case MEMDEV_IOCGETMONITOR:
        sMonitor.top_temp = *((short *)(data_map_addr + TOP_MONITOR_TEMP_OFFSET));
        sMonitor.top_hv = *((short *)(data_map_addr + TOP_MONITOR_HV_OFFSET));
        sMonitor.top_12v = *((short *)(data_map_addr + TOP_MONITOR_12V_OFFSET));
        sMonitor.top_8v = *((short *)(data_map_addr + TOP_MONITOR_8V_OFFSET));
        sMonitor.top_5v = *((short *)(data_map_addr + TOP_MONITOR_5V_OFFSET));
        sMonitor.top_3v = *((short *)(data_map_addr + TOP_MONITOR_3V3_OFFSET));
        sMonitor.main_3v3 = (*((short *)(data_map_addr + MAIN_MONITOR_3V3_OFFSET))) & 0x0fff;
        sMonitor.main_temp = (*((short *)(data_map_addr + MAIN_MONITOR_TEMP_OFFSET))) & 0x0fff;
        sMonitor.main_pi = (*((short *)(data_map_addr + MAIN_MONITOR_PI_OFFSET))) & 0x0fff;
        sMonitor.main_pv = (*((short *)(data_map_addr + MAIN_MONITOR_PV_OFFSET))) & 0x0fff;
        sMonitor.main_5v = (*((short *)(data_map_addr + MAIN_MONITOR_5V_OFFSET))) & 0x0fff;
        //			printk("top:hv=0x%x,temp=0x%x;main:pv=0x%x\r\n",sMonitor.top_hv,sMonitor.top_temp,sMonitor.main_pv);
        ret = copy_to_user((struct S_Monitor *)arg, &sMonitor, sizeof(struct S_Monitor));
        break;
    default:
        ret = -EINVAL;
    }
    return ret;
}

static struct file_operations irq_fops = {
    .owner = THIS_MODULE,
    .open = irq_drv_open,
    .read = irq_drv_read,
    .write = irq_drv_write,
    .fasync = irq_drv_fasync,
    .release = irq_drv_release,
    .unlocked_ioctl = irq_ioctl,
};

static irqreturn_t irq_interrupt(int irq, void *dev_id)
{
    schedule_work(&work);
    return IRQ_HANDLED;
}

static int irq_probe(struct platform_device *pdev)
{
    int err;
    struct device *tmp_dev;
    memset(devname, 0, 16);
    strcpy(devname, DEVICE_NAME);
    data_map_addr = ioremap(XPAR_BRAM_0_BASEADDR, MONITOR_OFFSET);
    socket_init();
    //set speed
    motor_map_addr = ioremap(MOTOR_BASEADDR, MOTOR_DATASIZE);
    Xil_Out32((unsigned int *)(motor_map_addr), 30000);
    //map gpio addr
    //	gpio_map_addr = ioremap(GPIO_BASEADDR,GPIO_DATASIZE);
    gpio_map_addr = GPIO_BASEADDR;
    //power top motor 0x2,
    writel((unsigned char)0x2, gpio_map_addr);
    printk("gpio value = %X\r\n", readl((unsigned int)gpio_map_addr));
#if 1
	int i;
	for (i=0;i<5;i++)
	{
		usleep_range(1000000, 1000001);
	}
#endif
    writel((unsigned char)(0x3), gpio_map_addr);
    printk("gpio value = %X\r\n", readl((unsigned int)gpio_map_addr));

    //init gpio file
    /*
	fp =filp_open("/sys/class/gpio/gpio902/value",O_RDWR | O_CREAT,0644);
	if (IS_ERR(fp)){
        	printk("create file error/n");
        	return -1;
   	}
*/
    //	fs =get_fs();
    //    	set_fs(KERNEL_DS);
    major = register_chrdev(0, devname, &irq_fops);
    cls = class_create(THIS_MODULE, devname);
    mijor = 1;
    tmp_dev = device_create(cls, &pdev->dev, MKDEV(major, mijor), NULL, devname);
    if (IS_ERR(tmp_dev))
    {
        class_destroy(cls);
        unregister_chrdev(major, devname);
        return 0;
    }
    irq = platform_get_irq(pdev, 0);
    if (irq <= 0)
        return -ENXIO;
    dev = &pdev->dev;
    err = request_threaded_irq(irq, NULL,
                               irq_interrupt,
                               IRQF_TRIGGER_RISING | IRQF_ONESHOT,
                               devname, NULL);
    if (err)
    {
        printk(KERN_ALERT "irq_probe irq error=%d\n", err);
        goto fail;
    }
    else
    {
        printk("irq = %d\n", irq);
        printk("devname = %s\n", devname);
    }
    return 0;

fail:

    free_irq(irq, NULL);
    device_destroy(cls, MKDEV(major, mijor));
    class_destroy(cls);
    unregister_chrdev(major, devname);
    return -ENOMEM;
}

static int irq_remove(struct platform_device *pdev)
{
    device_destroy(cls, MKDEV(major, mijor));
    class_destroy(cls);
    unregister_chrdev(major, devname);
    free_irq(irq, NULL);
    printk("irq = %d\n", irq);
    return 0;
}

static int irq_suspend(struct device *dev)
{
    return 0;
}

static int irq_resume(struct device *dev)
{
    return 0;
}

static const struct dev_pm_ops irq_pm_ops = {
    .suspend = irq_suspend,
    .resume = irq_resume,
};

//MODULE_DEVICE_TABLE(platform, irq_driver_ids);

static const struct of_device_id irq_of_match[] = {
    {.compatible = "hello,irq"},
    {}};
MODULE_DEVICE_TABLE(of, irq_of_match);

static struct platform_driver irq_driver = {
    .probe = irq_probe,
    .remove = irq_remove,
    .driver = {
        .owner = THIS_MODULE,
        .name = "irq@0",
        .pm = &irq_pm_ops,
        .of_match_table = irq_of_match,
    },
};

module_platform_driver(irq_driver);

MODULE_LICENSE("GPL v2");
