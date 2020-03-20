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
static int major = 0;
static int mijor = 1;
static struct class *cls;
static int gpio_irq;
//static struct device *dev;
#define DEVICE_NAME "irq_drv"
#define SERVER_IP "192.168.19.134"
#define DEST_IP_FILE "/var/ftp/destip.txt"
#define PORT 2368
#define UDP_DATASIZE 1206
#define RADAR_DATA_VS_TOP_MONITOR_SIZE 0x500 //0x4cb
#define RADAR_DATA_VS_TOP_MONITOR_BASEADDR 0x43C10000
#define MOTOR_PARAM_BASEADDR 0x43C20000
#define MOTOR_PARAM_DATASIZE 0x40
#define MOTOR_READ_SPEED_OFFSET 32

//#define GPIO_BASEADDR  0x41200000
#define GPIO_BASEADDR 0xd0840008
#define GPIO_DATASIZE 8

#define TOP_MONITOR_TEMP_OFFSET 0x4c4 /*顶板温度*/
#define TOP_MONITOR_HV_OFFSET 0x4c2   /*顶板采样高压*/
#define TOP_MONITOR_12V_OFFSET 0x4c0  /*顶板12V*/
#define TOP_MONITOR_8V_OFFSET 0x4ca   /*顶板8V*/
#define TOP_MONITOR_5V_OFFSET 0x4c8   /*顶板5V*/
#define TOP_MONITOR_3V3_OFFSET 0x4c6  /*顶板3V3*/
//底板
#define MAIN_MONITOR_BASEADDR 0x43C30000
#define MAIN_MONITOR_SIZE 0x30
#define MAIN_MONITOR_3V3_OFFSET 0x24
#define MAIN_MONITOR_TEMP_OFFSET 0x28
#define MAIN_MONITOR_PI_OFFSET 0x22
#define MAIN_MONITOR_PV_OFFSET 0x20
#define MAIN_MONITOR_5V_OFFSET 0x2c

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
#define MEMDEV_IOC_MAXNR 6
#define MEMDEV_IOCPRINT _IO(MEMDEV_IOC_MAGIC, 1)
#define MEMDEV_IOCGETDATA _IOR(MEMDEV_IOC_MAGIC, 2, int)
#define MEMDEV_IOCSETSPEED _IOW(MEMDEV_IOC_MAGIC, 3, int)
#define MEMDEV_IOCGETMONITOR _IOR(MEMDEV_IOC_MAGIC, 4, struct S_Monitor)
#define MEMDEV_IOCSETGPIO _IOW(MEMDEV_IOC_MAGIC, 5, int)
#define MEMDEV_IOCSETMOTORPARAM _IOW(MEMDEV_IOC_MAGIC, 6, int *)
char *dest_ip_addr = NULL;
char *radarData_map_addr = NULL;
char *topMonitor_map_addr = NULL;
char *mainMonitor_map_addr = NULL;
char *motorParam_map_addr = NULL;
char *gpio_map_addr = NULL;
static struct socket *sock = NULL;
static struct work_struct work;
static volatile int irq_is_open = 0;
static struct fasync_struct *irq_async;

static int udp_sendto(struct socket *sock, char *buff, size_t len, unsigned flags, struct sockaddr *addr, int addr_len)
{
    struct kvec vec;
    struct msghdr msg;
    int ret;
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

static void sendmsg(void *dummy)
{
    struct sockaddr_in addr;
    memset(&addr, 0x00, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PORT);
    if (dest_ip_addr != NULL)
    {
        addr.sin_addr.s_addr = in_aton(dest_ip_addr);
    }
    else
    {
        printk("dest ip did not set yet.\n");
        return;
    }
    udp_sendto(sock, radarData_map_addr, UDP_DATASIZE, 0, (struct sockaddr *)&addr, sizeof(addr));
}

static int socket_init(void)
{
    struct file *filp;
    mm_segment_t fs;
    int n = 0;
    loff_t pos;
    int ip_buff[0x10];
    filp = filp_open(DEST_IP_FILE, O_RDONLY, 0);
    if (IS_ERR(filp))
    {
        printk("open destination ip file error.\n");
        dest_ip_addr = SERVER_IP;
    }
    else
    {
        fs = get_fs();
        set_fs(KERNEL_DS); //将内核可访问空间扩展到用户区
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
        filp_close(filp, NULL);
        set_fs(fs);
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

#define MOTOR_PARAM_SIZE 8
#define GPIO_LASER_OFF 0xFE // 1111 1110
#define GPIO_LASER_ON 0x1   // 0000 0001 GPIO[0]
#define GPIO_MOTOR_OFF 0xFD // 1111 1101
#define GPIO_MOTOR_ON 0x2   // 0000 0010 GPIO[1]
#define GPIO_RING_OFF 0xF7  // 1111 0111
#define GPIO_RING_ON 0x8    // 0000 1000 GPIO[3]
#define GPIO_PARAM_OFF 0xEF // 1110 1111
#define GPIO_PARAM_ON 0x10  // 0001 0000 GPIO[4]
#define GPIO_DEBUG_OFF 0xDF //1101 1111
#define GPIO_DEBUG_ON 0x20  //0010 0000 GPIO[5]
enum
{
    ENUM_SET_SPEED = 0,
    ENUM_DEAD_ZONE,
    ENUM_ADVANCE_ANGLE,
    ENUM_AR_PERIOD,
    ENUM_ASR_KP,
    ENUM_ASR_KI,
    ENUM_ACR_KP,
    ENUM_ACR_KI
};
#define SET_SPEED_OFFSET 0
#define DEAD_ZONE_OFFSET 18
#define ADVANCE_ANGLE_OFFSET 16
#define AR_PERIOD_OFFSET 4
#define ASR_KP_OFFSET 10
#define ASR_KI_OFFSET 8
#define ACR_KP_OFFSET 14
#define ACR_KI_OFFSET 12
int irq_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{

    int err = 0;
    int ret = 0;
    int speed = 0;
    int gpioSet = 0;
    int i = 0;
    int iMotorParam[MOTOR_PARAM_SIZE] = {0};
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
    case MEMDEV_IOCSETMOTORPARAM:
        ret = copy_from_user(iMotorParam, arg, MOTOR_PARAM_SIZE * sizeof(int));
        iMotorParam[ENUM_SET_SPEED] *= 10;
        iMotorParam[ENUM_AR_PERIOD] *= 100000;
        printk("SET_SPEED = %d\n", iMotorParam[ENUM_SET_SPEED]);
        writel(iMotorParam[ENUM_SET_SPEED], (unsigned int *)(motorParam_map_addr + SET_SPEED_OFFSET));
        writeb((unsigned char)(iMotorParam[ENUM_DEAD_ZONE]), (unsigned char *)(motorParam_map_addr + DEAD_ZONE_OFFSET));
        writew((unsigned short)(iMotorParam[ENUM_ADVANCE_ANGLE]), (unsigned short *)(motorParam_map_addr + ADVANCE_ANGLE_OFFSET));
        writel(iMotorParam[ENUM_AR_PERIOD], (unsigned int *)(motorParam_map_addr + AR_PERIOD_OFFSET));
        writew((unsigned short)(iMotorParam[ENUM_ASR_KP]), (unsigned short *)(motorParam_map_addr + ASR_KP_OFFSET));
        writew((unsigned short)(iMotorParam[ENUM_ASR_KI]), (unsigned short *)(motorParam_map_addr + ASR_KI_OFFSET));
        writew((unsigned short)(iMotorParam[ENUM_ACR_KP]), (unsigned short *)(motorParam_map_addr + ACR_KP_OFFSET));
        writew((unsigned short)(iMotorParam[ENUM_ACR_KI]), (unsigned short *)(motorParam_map_addr + ACR_KI_OFFSET));
        break;
    case MEMDEV_IOCSETSPEED:
        ret = get_user(speed, (int *)arg);
        printk("set speed = %d\n", speed);
        writel((unsigned int *)(motorParam_map_addr + SET_SPEED_OFFSET), speed);
        break;
    case MEMDEV_IOCGETDATA:
        speed = readl((unsigned int *)(motorParam_map_addr + MOTOR_READ_SPEED_OFFSET));
        ret = put_user(speed, (int *)arg);
        break;
    case MEMDEV_IOCSETGPIO:
        ret = get_user(gpioSet, (int *)arg);
        printk("set gpioSet = 0x%X\n", gpioSet);
        switch (gpioSet)
        {
        case GPIO_LASER_OFF:
        case GPIO_MOTOR_OFF:
        case GPIO_RING_OFF:
        case GPIO_PARAM_OFF:
        case GPIO_DEBUG_OFF:
            writeb((unsigned char)(gpioSet & readl(gpio_map_addr)), gpio_map_addr);
            break;
        case GPIO_LASER_ON:
        case GPIO_MOTOR_ON:
        case GPIO_RING_ON:
        case GPIO_PARAM_ON:
        case GPIO_DEBUG_ON:
            writeb((unsigned char)(gpioSet | readl(gpio_map_addr)), gpio_map_addr);
            break;
        default:
            break;
        }
        break;
    case MEMDEV_IOCGETMONITOR:
        sMonitor.top_temp = *((short *)(topMonitor_map_addr + TOP_MONITOR_TEMP_OFFSET));
        sMonitor.top_hv = *((short *)(topMonitor_map_addr + TOP_MONITOR_HV_OFFSET));
        sMonitor.top_12v = *((short *)(topMonitor_map_addr + TOP_MONITOR_12V_OFFSET));
        sMonitor.top_8v = *((short *)(topMonitor_map_addr + TOP_MONITOR_8V_OFFSET));
        sMonitor.top_5v = *((short *)(topMonitor_map_addr + TOP_MONITOR_5V_OFFSET));
        sMonitor.top_3v = *((short *)(topMonitor_map_addr + TOP_MONITOR_3V3_OFFSET));
        sMonitor.main_3v3 = (*((short *)(mainMonitor_map_addr + MAIN_MONITOR_3V3_OFFSET))) & 0x0fff;
        sMonitor.main_temp = (*((short *)(mainMonitor_map_addr + MAIN_MONITOR_TEMP_OFFSET))) & 0x0fff;
        sMonitor.main_pi = (*((short *)(mainMonitor_map_addr + MAIN_MONITOR_PI_OFFSET))) & 0x0fff;
        sMonitor.main_pv = (*((short *)(mainMonitor_map_addr + MAIN_MONITOR_PV_OFFSET))) & 0x0fff;
        sMonitor.main_5v = (*((short *)(mainMonitor_map_addr + MAIN_MONITOR_5V_OFFSET))) & 0x0fff;
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

static int radar_init(struct platform_device *pDev)
{
    int i = 0;
    int err = 0;
    socket_init();
    radarData_map_addr = ioremap(RADAR_DATA_VS_TOP_MONITOR_BASEADDR, RADAR_DATA_VS_TOP_MONITOR_SIZE);
    mainMonitor_map_addr = ioremap(MAIN_MONITOR_BASEADDR, MAIN_MONITOR_SIZE);
    motorParam_map_addr = ioremap(MOTOR_PARAM_BASEADDR, MOTOR_PARAM_DATASIZE);
    topMonitor_map_addr = radarData_map_addr;
    gpio_map_addr = GPIO_BASEADDR;
/*
    //set speed 300 * 10
    writel((unsigned int)3000, (unsigned int *)(motorParam_map_addr + SET_SPEED_OFFSET));
    //power on motor: 0010 b
    writeb((unsigned char)0x2, gpio_map_addr);
    //sleep 5s
    for (i = 0; i < 5; i++)
    {
        usleep_range(1000000, 1000001);
    }
    //powner on main board: (001 | 010) b
    writeb((unsigned char)(0x3), gpio_map_addr);
*/
    //init irq
    gpio_irq = platform_get_irq(pDev, 0);
    if (gpio_irq <= 0)
        return -ENXIO;
    err = request_threaded_irq(gpio_irq, NULL,
                               irq_interrupt,
                               IRQF_TRIGGER_RISING | IRQF_ONESHOT,
                               devname, NULL);
    if (err)
    {
        printk(KERN_ALERT "irq_probe gpio_irq error=%d\n", err);
        free_irq(gpio_irq, NULL);
    }
    else
    {
        printk("gpio_irq = %d\n", gpio_irq);
    }
    return err;
}
static int irq_probe(struct platform_device *pdev)
{
    struct device *tmp_dev;
    memset(devname, 0, 16);
    strcpy(devname, DEVICE_NAME);
    mijor = 1;
    major = register_chrdev(0, devname, &irq_fops);
    cls = class_create(THIS_MODULE, devname);
    tmp_dev = device_create(cls, &pdev->dev, MKDEV(major, mijor), NULL, devname);
    if (IS_ERR(tmp_dev))
    {
        printk("devname = %s\n", devname);
        class_destroy(cls);
        unregister_chrdev(major, devname);
        device_destroy(cls, MKDEV(major, mijor));
        return -ENOMEM;
    }
    radar_init(pdev);
    return 0;
}

static int irq_remove(struct platform_device *pdev)
{
    device_destroy(cls, MKDEV(major, mijor));
    class_destroy(cls);
    unregister_chrdev(major, devname);
    free_irq(gpio_irq, NULL);
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

static const struct of_device_id irq_of_match[] = {
    {.compatible = "radar,irq"},
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
