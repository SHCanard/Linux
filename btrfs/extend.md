## Extend system LVM

#fdisk /dev/sda

Welcome to fdisk (util-linux 2.36.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sda: 120 GiB, 128849018880 bytes, 251658240 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 500D0978-6EC8-49B9-AA85-C15226AD2BAF

Device       Start       End   Sectors  Size Type
/dev/sda1     2048   1050623   1048576  512M EFI System
/dev/sda2  1050624 209715166 208664543 99.5G Linux LVM

Command (m for help): d
Partition number (1,2, default 2):

Partition 2 has been deleted.

Command (m for help): n
Partition number (2-128, default 2):
First sector (1050624-251658206, default 1050624):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-251658206, default 251658206):

Created a new partition 2 of type 'Linux filesystem' and of size 119.5 GiB.
Partition #2 contains a LVM2_member signature.

Do you want to remove the signature? [Y]es/[N]o: N

Command (m for help): w

The partition table has been altered.
Syncing disks.

#pvresize /dev/sda2

#lvextend -l +100%FREE /dev/system/root

#btrfs filesystem resize max /
