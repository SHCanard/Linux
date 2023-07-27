#ANSSI-BP-028 (intermediary)

Separate:
/srv
/var/log/audit
/var/log
/boot
/var
/tmp
/opt
/usr
/var/tmp
/home

Add the noexec option to the fourth column of /etc/fstab for the line which controls mounting of /home, /var, /boot, /var/tmp, /tmp, /var/log

Add the nosuid option to the fourth column of /etc/fstab for the line which controls mounting of /var/log, /srv, /var/tmp, /opt, /home, /tmp, /var, /boot

Add the nodev option to the fourth column of /etc/fstab for the line which controls mounting of any non-root local partitions

