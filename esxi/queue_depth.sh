## Exemple to correctly set the queue depth to 254

#get fiberchannel queue depth
esxcli system module parameters list -m nfnic
#Name                      Type   Value  Description
#------------------------  -----  -----  --------------------------------------------------------------
#lun_queue_depth_per_path  ulong  254    nfnic lun queue depth per path: Default = 32. Range [1 - 1024]

#get device queue depth
esxcli storage core device list -d naa.xxxxx
#[...]
# Device Max Queue Depth: 64
# No of outstanding IOs with competing worlds: 32

#change device queue depth
esxcli storage core device set -m 254 -d naa.xxxxx
#Unable to set device's max-queue-depth or current-queue-depth. Error was: Unable to complete Sysinfo operation.  Please see the VMkernel log file for more details.: Sysinfo error: Bad parameterSee VMkernel log for details.
#vmkernel.log:
#2022-02-16T19:00:47.343Z [...] 2966: Can't set the maxPathQueueDepth value to more than device advertised maxPathQueueDepth 64

# Read the following articles for better understanding:
# https://www.codyhosterman.com/2017/02/understanding-vmware-esxi-queuing-and-the-flasharray/

#the host bus adapter is blocking the limit
esxcli system module list | grep qln
#qlnativefc                          true        true
#host bus adapter is Qlogic, so:
esxcli system module parameters set -p ql2xmaxqdepth=254 -m qlnativefc

#reboot is needed, and then:
esxcli storage core device list -d naa.xxxxx
#[...]
# Device Max Queue Depth: 254
# No of outstanding IOs with competing worlds: 32
# "No of outstanding IOs with competing worlds" only affects sceanrios where several VMs/LUN share the same datastore. Does not impact RDM.

#to check impact
esxtop
# "u" for the disks view, and look at "DQLEN" (configured max queue lenght), "ACT" (if equals DQLEN then the device queue lenght is filled), "QUED" (the number of IOPS wainting).
