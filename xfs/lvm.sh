# Force devices rescan
echo '1' > /sys/class/scsi_disk/0\:0\:0\:0/device/rescan
echo 1>/sys/class/block/sd[X]/device/rescan

# Edit partition table
fdisk /dev/sd[X]

# Inform the OS of partition table changes
partprobe

# Resize physical volume
pvresize /dev/sd[X]1

# Create Volume Group
vgcreate -s 4M [Volume Group Name] [list of all disks]

# Create Logical Volume
lvcreate -n [Logical Volume Name] -L [Size of Logical Volume] -i [Number of LUNs in the volume group] -I 4M [Volume Group Name]

# Extend Logical Volume
lvcreate -l +100%FREE [Logical Volume Device]

# Create File System
mkfs.xfs -K [Logical Volume Device]

# Extend File System
xfs_growfs [Logical Volume Device]
