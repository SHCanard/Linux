echo 1>/sys/class/block/sda/device/rescan

fdisk /dev/sda
#delete/recreate partitions

free -m
#ensure RAM is not full and can contain used swap space

sync

echo 3 > /proc/sys/vm/drop_caches

free -m

swapoff -a

partx -u /dev/sda

mkswap /dev/sda3

vi /etc/fstab
#replace previous UUID with the one returned by the previous command

swapon -a
