
#!/bin/bash
# 添加mod
CONFIGFS_HOME=/sys/kernel/config
insmod libcomposite.ko
insmod usb_f_fs.ko
insmod usb_f_hid.ko
modprobe libcomposite  # 加入驱动
mkdir -p $CONFIGFS_HOME/usb_gadget/m1 # 在usb_gadget 中创建我们设备的文件夹
# 当我们创建完这个文件夹之后，系统自动的在这个文件夹中创建usb相关的内容 ，这些内容需要由创建者自己填写。
cd $CONFIGFS_HOME/usb_gadget/m1
echo "0x0104" > idVendor # 写入我们自定义的usb vid
echo "0x1d6b" > idProduct# 写入我们自定义的usb pid
mkdir strings/0x409 # 创建字符串文件夹
echo "831409-0000" > strings/0x409/serialnumber
echo "Logitech" > strings/0x409/manufacturer
echo "Logitech G Pro Wireless" > strings/0x409/product
# 创换配置功能
#$mkdir configs/<name>.<number>
mkdir -p configs/c.1/strings/0x409
echo 0x80 > configs/c.1/bmAttributes # usb 硬件参数
echo 100 > configs/c.1/MaxPower # usb 硬件参数 最大电流100 mA
echo "Configuration" > configs/c.1/strings/0x409/configuration
#定义hid 设备
mkdir -p functions/hid.usb0
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 3 > functions/hid.usb0/report_length
echo -ne \\x05\\x01\\x09\\x02\\xa1\\x01\\x09\\x01\\xa1\\x00\\x05\\x09\\x19\\x01\\x29\\x03\\x15\\x00\\x25\\x01\\x95\\x03\\x75\\x01\\x81\\x02\\x95\\x01\\x75\\x05\\x81\\x03\\x05\\x01\\x09\\x30\\x09\\x31\\x15\\x81\\x25\\x7f\\x75\\x08\\x95\\x02\\x81\\x06\\xc0\\xc0 > functions/hid.usb0/report_desc
# Write report descriptor hex值
# Link the configuration file
ln -s functions/hid.usb0 configs/c.1
# Activate device
ls /sys/class/udc > UDC  #当我们执行完这条命令后，系统就自动的帮我们创建了ubs hid 设备，
