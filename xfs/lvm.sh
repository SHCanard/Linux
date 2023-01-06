# Create Volume Group
vgcreate -s 4M [Volume Group Name] [list of all disks]

# Create Logical Volume
lvcreate -n [Logical Volume Name] -L [Size of Logical Volume] -i [Number of LUNs in the volume group] -I 4M [Volume Group Name]

# Create File System
mkfs.xfs -K [Logical Volume Device]
